import psycopg2
from psycopg2 import sql
from psycopg2.extras import execute_values
import polars as pl
import numpy as np
import warnings
import logging

# Configure logging
logging.basicConfig(
    filename="migration.log",
    filemode="w",
    level=logging.NOTSET,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

warnings.filterwarnings("ignore")


class DBManager:
    def __init__(
        self,
        dbname="central_health",
        user="postgres",
        password="1234",
        host="localhost",
        port=5432,
    ):
        self.dbname = dbname
        self.user = user
        self.password = password
        self.host = host
        self.port = port
        self.conn = None

    def connect(self):
        try:
            # Attempt to connect to the database
            self.conn = psycopg2.connect(
                dbname=self.dbname,
                user=self.user,
                password=self.password,
                host=self.host,
                port=self.port,
            )
            logging.info("Connected to the database.")
        except psycopg2.OperationalError as e:
            logging.warning(f"Database connection failed: {e}")
            raise

        return self.conn


class Migration:
    def __init__(self, conn: DBManager.connect, schema_file="schema.sql"):
        self.schema_file = schema_file
        self.budget_transaction_df = None
        self.journal_transaction_df = None
        self.ownership_df = None
        self.conn = conn

    def migrate(self) -> None:
        try:
            self.__apply_schema()
            self.__read_seed_files()
            self.__migrate_account_data()
            self.__migrate_business_unit_data()
            self.__migrate_rad_data()

            logging.info("All data imported successfully.")
        except Exception as e:
            logging.exception(f"Error during migration: {e}")

    def __apply_schema(self) -> None:
        try:
            with self.conn.cursor() as cursor:
                with open(self.schema_file, "r") as schema:
                    cursor.execute(schema.read())
                    self.conn.commit()
                    logging.info("Schema applied successfully.")
        except Exception as e:
            logging.error(f"Failed to apply schema: {e}", exc_info=True)
            raise

    def __read_seed_files(self) -> None:
        excel_config = {
            "source": "../seed/ownership.xlsx",
            "drop_empty_cols": False,
            "raise_if_empty": True,
            "sheet_name": "Layer1",
            "engine": "calamine",
            "schema_overrides": {
                "Description": pl.Utf8,
                "AccountNo": pl.Utf8,
                "AccountType": pl.Utf8,
                "BusinessUnitId": pl.Utf8,
            },
        }
        self.ownership_df = pl.read_excel(**excel_config)
        csv_config = {"ignore_errors": True, "infer_schema": True}
        self.budget_transaction_df = pl.read_csv("../seed/bt.csv", **csv_config)
        self.journal_transaction_df = pl.read_csv("../seed/jt.csv", **csv_config)

    def __migrate_account_data(self) -> None:
        df = (
            self.ownership_df.clone()[:, :-2]
            .filter(pl.col("AccountNo") != "")
            .with_columns(
                pl.all().str.strip_chars(),
                pl.when(pl.col("AccountType") == "")
                .then(None)
                .otherwise(pl.col("AccountType")),
            )
            .drop("AccountType")
            .rename(
                {
                    "Description": "account",
                    "AccountNo": "account_no",
                    "ParentKey": "parent_account_no",
                    "literal": "account_type",
                }
            )
            .unique(
                subset="account_no"
            )  # remove 16100 for advance rec recursive bullshit
        )

        # first upload the accounts
        accounts = df.clone().select(["account_no", "account", "account_type"])
        rows = accounts.to_dicts()
        self.__insert_many("account", rows)

        # second upload the account ownership
        ownerships = df.clone().select(["account_no", "parent_account_no"])
        rows = ownerships.to_dicts()
        self.__insert_many("account_ownership", rows)

    def __migrate_business_unit_data(self) -> None:
        df = (
            self.ownership_df.clone()
            .select(["Description", "BusinessUnitId", "ParentKey"])
            .filter(pl.col("BusinessUnitId") != "")
            .with_columns(pl.all().str.strip_chars())
            .rename(
                {
                    "Description": "business_unit",
                    "BusinessUnitId": "business_unit_id",
                    "ParentKey": "parent_business_unit_id",
                }
            )
        )

        # first upload the accounts
        business_units = df.clone().select(["business_unit_id", "business_unit"])
        rows = business_units.to_dicts()
        self.__insert_many("business_unit", rows)

        # second upload the account ownership
        ownerships = df.clone().select(["business_unit_id", "parent_business_unit_id"])
        rows = ownerships.to_dicts()
        self.__insert_many("business_unit_ownership", rows)

    def __migrate_rad_data(self) -> None:
        df = (
            self.journal_transaction_df.clone()
            .select(
                [
                    col
                    for col in self.journal_transaction_df.columns
                    if "RAD" in col and "Unused" not in col
                ]
            )
            .unique()
        )

        description_columns = [col for col in df.columns if "Description" in col]

        for desc_col in description_columns:
            prefix = desc_col.replace(
                " Description", ""
            )  # Get the prefix by removing " Description"
            if (
                prefix in df.columns
            ):  # Check if the corresponding non-description column exists
                new_col = (
                    pl.when(
                        pl.col(desc_col).is_not_null() & pl.col(prefix).is_not_null()
                    )
                    .then(
                        pl.concat_str([pl.col(desc_col), pl.col(prefix)], separator="|")
                    )
                    .otherwise(None)
                    .alias(f"{prefix} Combined")
                )

                df = df.with_columns(new_col)

        # Select all "Combined" columns
        combined_columns = [col for col in df.columns if "Combined" in col]

        melted = (
            df.select(combined_columns)
            .melt(
                id_vars=[],
                variable_name="parent_rad_id",
                value_name="combined_id",
            )
            .with_columns(
                pl.col("parent_rad_id")
                .str.replace("RAD Combined", "")
                .str.strip_chars()
            )
            .unique()
            .drop_nulls(subset="combined_id")
        )

        data = []

        for row in melted.to_dicts():
            parent_rad_id = row["parent_rad_id"]
            combined_id = row["combined_id"]
            rad = combined_id.split("|")[0]
            rad_id = combined_id.split("|")[1]
            data.append({"parent_rad_id": parent_rad_id, "rad": rad, "rad_id": rad_id})

        rad = pl.DataFrame(data).drop("parent_rad_id")
        rows = rad.to_dicts()
        self.__insert_many("rad", rows)

    def __insert_many(self, table_name: str, rows: dict) -> int | None:
        try:
            with self.conn.cursor() as cur:
                # Get column names from the first row (assuming all rows have the same structure)
                columns = ", ".join(rows[0].keys())

                # Create placeholders for the values
                placeholders = ", ".join(["%s"] * len(rows[0]))

                # Construct the SQL INSERT statement
                sql = f"INSERT INTO multiview.{table_name} ({columns}) VALUES ({placeholders})"

                # Prepare the data for execution
                data = [tuple(row.values()) for row in rows]

                # Execute the INSERT statement with the provided data
                for row in data:
                    cur.execute(sql, row)
                    self.conn.commit()

                logging.info(f"{len(data)} rows inserted into [{table_name}]")

        except (Exception, psycopg2.Error) as error:
            logging.exception("Error while inserting to PostgreSQL", error)
            raise


if __name__ == "__main__":
    try:
        db_manager = DBManager()
        conn = db_manager.connect()

        if conn:
            migration = Migration(conn=conn, schema_file="schema.sql")
            migration.migrate()
    except Exception as error:
        logging.exception(error)
        raise
