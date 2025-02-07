import psycopg2
import polars as pl
import warnings
import logging
import re
import json

# Configure logging
logging.basicConfig(
    filename=".log",
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
    def __init__(self, conn: DBManager.connect):
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
            self.__migrate_budget_data()
            self.__migrate_journal_data()

            logging.info("All data imported successfully.")
        except Exception as e:
            logging.exception(f"Error during migration: {e}")

    def __apply_schema(self) -> None:
        try:
            with self.conn.cursor() as cursor:
                with open("schema/tables.sql", "r") as file:
                    cursor.execute(file.read())
                    self.conn.commit()
                    logging.info("Tables Schema applied successfully.")

                with open("schema/func.sql", "r") as file:
                    cursor.execute(file.read())
                    self.conn.commit()
                    logging.info("Functions Schema applied successfully.")

                with open("schema/templates.sql", "r") as file:
                    cursor.execute(file.read())
                    self.conn.commit()
                    logging.info("Templates Schema applied successfully.")
        except Exception as e:
            logging.error(f"Failed to apply schema: {e}", exc_info=True)
            raise

    def __read_seed_files(self) -> None:
        excel_config = {
            "source": "./seed/ownership.xlsx",
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

        csv_config = {
            "ignore_errors": True,
            "schema_overrides": {
                "Business Unit Id": pl.Utf8,
                "Account No.": pl.Utf8,
                "Amount": pl.Utf8,
                "Accoutning Date": pl.Date,
            },
        }
        self.budget_transaction_df = pl.read_csv("./seed/bt.csv", **csv_config)
        self.journal_transaction_df = pl.read_csv("./seed/jt.csv", **csv_config)

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
        stack = [self.budget_transaction_df, self.journal_transaction_df]
        seen_combinations = set()
        rows = []

        for frame in stack:
            df = (
                frame.clone()
                .select(
                    [
                        col
                        for col in self.journal_transaction_df.columns
                        if "RAD" in col
                        and "Unused" not in col
                        and "Description" not in col
                    ]
                )
                .unique()
            )

            for row in df.to_dicts():
                for key, value in row.items():
                    if value and key:
                        clean_key = key.replace("RAD", "").strip()
                        clean_value = value.strip()
                        combination = (clean_key, clean_value)

                        # add combo if not seen and then append rows for insert
                        if combination not in seen_combinations:
                            seen_combinations.add(combination)
                            rows.append(
                                {
                                    "rad_type_id": clean_key,
                                    "rad_id": clean_value,
                                }
                            )

        self.__insert_many("rad", rows)

    def __migrate_budget_data(self) -> None:
        budgets = (
            self.budget_transaction_df.clone()
            .select(
                [
                    "Budget Id",
                    "Business Unit Id",
                    "Account No.",
                    "Amount",
                    "Accounting Date",
                ]
                + [
                    col
                    for col in self.budget_transaction_df.columns
                    if "RAD" in col and "Unused" not in col and "Description" not in col
                ]
            )
            .rename(
                {
                    "Budget Id": "budget_id",
                    "Business Unit Id": "business_unit_id",
                    "Account No.": "account_no",
                    "Amount": "amount",
                    "Accounting Date": "accounting_date",
                }
            )
            .with_columns(
                [
                    pl.col("account_no").str.strip_chars(),
                    pl.col("business_unit_id").str.strip_chars(),
                    pl.col("amount")
                    .map_elements(self.clean_amount, return_dtype=pl.String)
                    .cast(pl.Float64),
                ]
            )
        )
        data = budgets.to_dicts()
        keys_to_select = [
            "budget_id",
            "business_unit_id",
            "account_no",
            "amount",
            "accounting_date",
            "rad_data",
        ]
        self.__insert_many(
            "budget", self.__construct_rad_json_data(keys_to_select, data)
        )

    def __migrate_journal_data(self) -> None:
        journals = (
            self.journal_transaction_df.clone()
            .select(
                [
                    "Entry Id",
                    "Business Unit Id",
                    "Account No",
                    "Amount",
                    "Accounting Date",
                    "Date Posted",
                ]
                + [
                    col
                    for col in self.budget_transaction_df.columns
                    if "RAD" in col and "Unused" not in col and "Description" not in col
                ]
            )
            .rename(
                {
                    "Entry Id": "entry_id",
                    "Business Unit Id": "business_unit_id",
                    "Account No": "account_no",
                    "Amount": "amount",
                    "Accounting Date": "accounting_date",
                    "Date Posted": "date_posted",
                }
            )
            .with_columns(
                [
                    pl.col("account_no").str.strip_chars(),
                    pl.col("business_unit_id").str.strip_chars(),
                    pl.col("amount")
                    .map_elements(self.clean_amount, return_dtype=pl.String)
                    .cast(pl.Float64),
                ]
            )
        )
        data = journals.to_dicts()
        keys_to_select = [
            "entry_id",
            "business_unit_id",
            "account_no",
            "amount",
            "accounting_date",
            "date_posted",
            "rad_data",
        ]
        self.__insert_many(
            "journal_entry", self.__construct_rad_json_data(keys_to_select, data)
        )

    def __construct_rad_json_data(
        self, keys_to_select: list, data: list[dict]
    ) -> list[dict]:
        rows = []

        for row in data:
            json_rad_list = []

            for key in row:
                if "RAD" in key and row[key]:
                    rad_type_id = key.replace(" RAD", "").strip()
                    rad_id = row[key]

                    json_rad_list.append(
                        {
                            "rad_type_id": rad_type_id,
                            "rad_id": rad_id,
                        }
                    )

            if json_rad_list:
                row["rad_data"] = json.dumps(json_rad_list)
            else:
                row["rad_data"] = None

            rows.append({key: row[key] for key in keys_to_select if key in row})

        return rows

    def __insert_many(self, table_name: str, rows: dict) -> int | None:
        try:
            with self.conn.cursor() as cur:
                # Get column names from the first row (assuming all rows have the same structure)
                columns = ", ".join(rows[0].keys())

                # Construct the SQL INSERT statement
                sql = f"INSERT INTO multiview.{table_name} ({columns}) VALUES "

                # Create a list of tuples with the values for each row
                data = [tuple(row.values()) for row in rows]

                # Create a list of strings, each representing a single row's values
                row_values = [f"({','.join(['%s'] * len(row))})" for row in data]

                # Join the row values with commas
                values_string = ",".join(row_values)

                # Construct the final SQL statement
                sql += values_string

                # Execute the INSERT statement with all data at once
                cur.execute(sql, [value for row in data for value in row])
                self.conn.commit()

                logging.info(f"{len(data)} rows inserted into [{table_name}]")

        except (Exception, psycopg2.Error) as error:
            logging.exception("Error while inserting to PostgreSQL", error)
            raise

    @staticmethod
    def clean_amount(value: str) -> str | None:
        if value:
            cleaned_str = re.sub(r"[^\d.-]", "", value)
            return cleaned_str
        else:
            return None


if __name__ == "__main__":
    try:
        db_manager = DBManager()
        conn = db_manager.connect()

        if conn:
            migration = Migration(conn=conn)
            migration.migrate()
    except Exception as error:
        logging.exception(error)
        raise
