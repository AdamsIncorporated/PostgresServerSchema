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
        config = {"ignore_errors": True, "infer_schema": True}
        self.ownership_df = pl.read_excel("../seed/ownership.xlsx")
        self.budget_transaction_df = pl.read_csv("../seed/bt.csv", **config)
        self.journal_transaction_df = pl.read_csv("../seed/jt.csv", **config)

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

        accounts = df.clone().select(["account_no", "account", "account_type"])
        rows = accounts.to_dicts()
        self.__insert_many("account", rows)

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

                logging.info(f"{len(data)} rows insrted into [{table_name}]")

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
