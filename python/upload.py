import psycopg2
from psycopg2 import sql
from psycopg2.extras import execute_values
import pandas as pd
import warnings
import numpy as np
import logging

# Configure logging
logging.basicConfig(
    filename="migration.log",
    filemode="w",
    level=logging.INFO,
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
        self.conn = conn

    def apply_schema(self):
        try:
            with self.conn.cursor() as cursor:
                with open(self.schema_file, "r") as schema:
                    cursor.execute(schema.read())
                    self.conn.commit()
                    logging.info("Schema applied successfully.")
        except Exception as e:
            logging.error(f"Failed to apply schema: {e}", exc_info=True)
            raise

    def import_all(self):
        try:
            self._import_account()
            self._import_rad_type()
            self._import_rad()
            self._import_business_unit()
            self._import_budget()
            self._import_budget_rad()
            self._import_journal_entry()
            self._import_journal_entry_rad()
            self._import_budget_entry_admin_view()
            logging.info("All data imported successfully.")
        except Exception as e:
            logging.exception(f"Error during import_all: {e}")

    def _import_account(self):
        account_raw = Util.read_csv_file(r"./source/Account.csv")
        account_ownership_raw = Util.read_csv_file(r"./source/AccountOwnership.csv")

        account_df = account_raw.copy()
        account_df = Util.sanitize_columns(account_df)
        account_df.dropna(inplace=True, subset="chart_id")
        account_df["date_created"] = pd.to_datetime(
            account_df["date_created"], errors="coerce"
        )

        account_ownership_df = account_ownership_raw.copy()
        account_ownership_df = Util.sanitize_columns(account_ownership_df)
        account_ownership_df.dropna(inplace=True, subset="account_no")
        account_ownership_df = account_ownership_df[["account_no", "parent_key_id"]]
        account_ownership_df["parent_key_id"] = account_ownership_df[
            "parent_key_id"
        ].str.replace("1_", "")
        merge = pd.merge(account_df, account_ownership_df, on="account_no")
        merge.rename(columns={"parent_key_id": "parent_account_no"}, inplace=True)

        table = "account"
        Util.import_func(merge, table, self.conn)

    def _import_rad_type(self):
        raw = Util.read_csv_file(r"./source/Rad.csv")
        rad = raw.copy()
        rad = Util.sanitize_columns(rad)
        rad = rad[["rad_type_id", "rad_type"]]
        rad = rad.drop_duplicates()

        table = "rad_type"
        Util.import_func(rad, table, self.conn)

    def _import_rad(self):
        raw = Util.read_csv_file(r"./source/Rad.csv")
        rad = raw.copy()
        rad = Util.sanitize_columns(rad)
        rad = rad[["rad_type_id", "rad_id", "rad"]]

        table = "rad"
        Util.import_func(rad, table, self.conn)

    def _import_business_unit(self):
        raw = Util.read_csv_file(r"./source/BusinessUnit.csv")
        df = (
            raw.copy()
            .pipe(Util.sanitize_columns)
            .assign(
                date_created=lambda x: pd.to_datetime(
                    x["date_created"], format="%m/%d/%Y"
                )
            )
            .applymap(lambda x: x.strip() if isinstance(x, str) else x)
        )

        table = "business_unit"
        Util.import_func(df, table, self.conn)

    def _import_budget_rad(self):
        raw = Util.read_csv_file(r"./source/Budget.csv")
        df = raw.copy()
        df = Util.sanitize_columns(df)
        df = df.reset_index(drop=True)
        df["id"] = df.index + 1

        df_split = df.copy()
        cols = [
            col for col in df_split.columns if "rad" in col and "description" not in col
        ]
        df_split[cols] = df_split[cols].applymap(
            lambda x: str(x) if not pd.isna(x) else np.nan
        )
        df_split["Combined"] = df_split[cols].apply(
            lambda row: "|".join([str(x) for x in row if not pd.isna(x)]), axis=1
        )
        df_split = df_split.assign(value=df_split["Combined"].str.split("|")).explode(
            "value"
        )
        df_result = df_split[["id", "value"]].reset_index(drop=True)
        df_result.replace("", float("NaN"), inplace=True)
        df_result.dropna(inplace=True)
        df_result.rename(columns={"value": "rad_id", "id": "budget_id"}, inplace=True)

        # combine the rad types and ids into the table
        sql = "SELECT rad_type_id, rad_id, rad FROM rad"
        rad_combined = Util.execute_query(sql, self.conn)
        merge = pd.merge(rad_combined, df_result, on=["rad_id"], how="right")

        table = "budget_rad"
        Util.import_func(merge, table, self.conn)

    def _import_budget(self):
        raw = Util.read_csv_file(r"./source/Budget.csv")
        df = raw.copy()
        df = Util.sanitize_columns(df)

        df["accounting_date"] = pd.to_datetime(
            df["accounting_date"], format="%m/%d/%Y", errors="coerce"
        )
        df["account_no"] = df["account_no"].astype(str).str.replace(".0", "")
        df["business_unit"] = df["business_unit"].astype(str)
        df["business_unit_id"] = df["business_unit_id"].astype(str)
        df["company_id"] = df["company_id"].astype(str)
        df["amount"] = df["amount"].str.replace(",", "").fillna(0).astype(float)

        table = "budget"
        Util.import_func(df, table, self.conn)

    def _import_journal_entry(self):
        raw = Util.read_csv_file(r"./source/JournalEntry.csv")
        df = raw.copy()
        df = Util.sanitize_columns(df)

        je = df.copy()
        je["accounting_date"] = pd.to_datetime(
            je["accounting_date"], format="%m/%d/%Y", errors="coerce"
        )
        je["amount"] = je["amount"].str.replace(",", "").fillna(np.nan).astype(float)
        je["business_unit_id"] = je["business_unit_id"].astype(str)
        je["entry_id"] = je["entry_id"].astype(str)
        je["company_id"] = je["company_id"].astype(str)

        table = "journal_entry"
        Util.import_func(je, table, self.conn)

    def _import_journal_entry_rad(self):
        raw = Util.read_csv_file(r"./source/JournalEntry.csv")
        df = raw.copy()
        df = Util.sanitize_columns(df)
        df = df.reset_index(drop=True)
        df["id"] = df.index + 1

        df["accounting_date"] = pd.to_datetime(
            df["accounting_date"], format="%m/%d/%Y", errors="coerce"
        )
        df_split = df.copy()
        cols = [
            col for col in df_split.columns if "rad" in col and "description" not in col
        ]

        df_split[cols] = df_split[cols].applymap(
            lambda x: str(x) if not pd.isna(x) else np.nan
        )
        df_split["Combined"] = df_split[cols].apply(
            lambda row: "|".join([str(x) for x in row if not pd.isna(x)]), axis=1
        )
        df_split = df_split.assign(value=df_split["Combined"].str.split("|")).explode(
            "value"
        )
        df_result = df_split[["id", "value"]].reset_index(drop=True)
        df_result.replace("", float("NaN"), inplace=True)
        df_result.dropna(inplace=True)
        df_result.rename(
            columns={"value": "rad_id", "id": "journal_entry_id"}, inplace=True
        )

        # combine the rad types and ids into the table
        sql = "SELECT rad_type_id, rad_id, rad FROM rad"
        rad_combined = Util.execute_query(sql, self.conn)
        merge = pd.merge(rad_combined, df_result, on=["rad_id"], how="right")

        table = "journal_entry_rad"
        Util.import_func(merge, table, self.conn)

    def _import_budget_entry_admin_view(self):
        raw = Util.read_csv_file(r"./source/BudgetEntryAdminView.csv")
        df = raw.copy()
        df = Util.sanitize_columns(df)

        sql = "SELECT rad_type_id, rad_id, rad FROM rad"
        rad_combined = Util.execute_query(sql, self.conn)
        merge = pd.merge(rad_combined, df, on=["rad"], how="right")

        # (1, null, null, Salaries, SAL, REG, Regular, null, null)

        table = "budget_entry_admin_view"
        Util.import_func(merge, table, self.conn)


class Util:
    @staticmethod
    def import_func(df: pd.DataFrame, table: str, conn) -> None:
        try:
            cursor = conn.cursor()

            # Fetch columns from the target table
            cursor.execute(
                "SELECT column_name FROM information_schema.columns WHERE table_name = %s",
                (table,),
            )
            table_columns = {row[0] for row in cursor.fetchall()}
            final = (
                df.copy(deep=True)
                .replace({np.nan: None, "": None})
                .applymap(lambda x: x.strip() if isinstance(x, str) else x)
                .loc[:, lambda x: x.columns.isin(table_columns)]
            )

            if final.empty:
                raise ValueError(
                    f"No matching columns to import into table {table}. Available columns: {table_columns}"
                )

            # Dynamically construct SQL INSERT statement
            columns = ", ".join([f"{col}" for col in final.columns])
            values_template = ", ".join(["%s"] * len(final.columns))
            insert_query = f"INSERT INTO {table} ({columns}) VALUES ({values_template})"

            # Convert DataFrame rows to a list of tuples
            rows = [tuple(row) for row in final.to_numpy()]

            if len(rows[0]) != len(final.columns):
                raise ValueError("Row length does not match number of columns in query")

            cursor.executemany(insert_query, rows)

            # Commit the transaction
            conn.commit()
            logging.info(f"Data imported into {table} successfully.")
        except Exception as error:
            logging.exception(f"Error importing data into {table}: {error}")
            raise error

    @staticmethod
    def execute_query(sql: str, conn) -> pd.DataFrame | None:
        try:
            df = pd.read_sql(sql, conn)
            logging.info(f"Data from query:\n{sql}\n successful.")
            return df
        except Exception as error:
            logging.exception(f"Error from query:\n{sql}\n {error}")
            raise error

    @staticmethod
    def sanitize_columns(df: pd.DataFrame) -> pd.DataFrame:
        df.columns = df.columns.str.replace(" ", "_").str.lower()
        df.columns = df.columns.str.replace("/", "")
        df.columns = df.columns.str.replace(".", "")
        return df

    @staticmethod
    def read_csv_file(path: str) -> pd.DataFrame:
        try:
            raw = pd.read_csv(path)
            logging.info(f"{path} data read from CSV.")
            return raw
        except Exception as e:
            logging.exception(f"Error reading {path}: {e}")
            return


if __name__ == "__main__":
    try:
        db_manager = DBManager()
        conn = db_manager.connect()

        if conn:
            migration = Migration(conn=conn, schema_file="schema.sql")
            migration.delete_all_tables()
            migration.apply_schema()
            migration.import_all()
    except Exception as error:
        raise error
