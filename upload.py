import sqlite3
import pandas as pd
import warnings
import numpy as np
import logging
import os

# Configure logging
logging.basicConfig(
    filename="migration.log",
    filemode="w",
    level=logging.INFO,
    format="%(asctime)s - %(levelname)s - %(message)s",
)

warnings.filterwarnings("ignore")


class DBManager:
    path: str = "main.db"
    conn: sqlite3.Connection = None

    def __init__(self):
        pass

    def connect(self):
        self.conn = sqlite3.connect(self.path)
        logging.info("Connected to the database.")

        return self.conn


class Migration:
    def __init__(self, db_name='main.db', schema_file='schema.sql'):
        self.db_name = db_name
        self.schema_file = schema_file

    def create_database(self):
        if not os.path.exists(self.db_name):
            self.connection = sqlite3.connect(self.db_name)
            logging.info(f"Database '{self.db_name}' created successfully.")
            self._run_schema()
        else:
            logging.info(f"Database '{self.db_name}' already exists.")

    def _run_schema(self):
        try:
            with open(self.schema_file, 'r') as file:
                schema_sql = file.read()
                cursor = self.connection.cursor()
                cursor.executescript(schema_sql)
                self.connection.commit()
                logging.info(f"Schema from '{self.schema_file}' applied successfully.")
        except Exception as e:
            logging.exception(f"An error occurred while applying the schema: {e}")
        finally:
            self.connection.close()

    def import_all(self):
        try:
            self._import_account()
            self._import_account_rad_type()
            self._import_budget_rad()
            self._import_budget()
            self.import_budget_entry_admin_view()
            self._import_journal_entry()
            self._import_journal_entry_rad()
            self._import_rad()
            self._import_rad_type()
            self._import_business_unit()
            logging.info("All data imported successfully.")
        except Exception as e:
            logging.exception(f"Error during import_all: {e}")

    def _import_account(self):
        try:
            account_raw = pd.read_csv(r"./source/Account.csv")
            logging.info("Account data read from CSV.")
        except Exception as e:
            logging.exception(f"Error Account CSV: {e}")
            return

        try:
            account_ownership_raw = pd.read_csv(r"./source/AccountOwnership.csv")
            logging.info("Account data read from CSV.")
        except Exception as e:
            logging.exception(f"Error Account CSV: {e}")
            return

        account_df = account_raw.copy()
        account_df.columns = account_df.columns.str.replace(" ", "")
        account_df.columns = account_df.columns.str.replace("-", "")
        account_df.dropna(inplace=True, subset="ChartId")
        account_df["ChartId"] = account_df["ChartId"].astype(int)

        account_ownership_df = account_ownership_raw.copy()
        account_ownership_df.columns = account_ownership_df.columns.str.replace(" ", "")
        account_ownership_df.dropna(inplace=True, subset="AccountNo")
        account_ownership_df = account_ownership_df[["AccountNo", "ParentKeyId"]]
        account_ownership_df["ParentKeyId"] = account_ownership_df[
            "ParentKeyId"
        ].str.replace("1_", "")
        merge = pd.merge(account_df, account_ownership_df, on="AccountNo")
        merge.rename(columns={"ParentKeyId": "ParentAccountNo"}, inplace=True)

        table = "Account"
        Util.import_func(merge, table)

    def _import_account_rad_type(self):
        try:
            raw = pd.read_csv(r"./source/Rad_Account.csv")
            logging.info("RAD Account data read from CSV.")
        except Exception as e:
            logging.exception(f"Error RAD Account CSV: {e}")
            return

        rad_account = raw.copy()
        rad_account.columns = rad_account.columns.str.replace(" ", "")
        rad_account["AccountNo"] = rad_account["AccountNo"].astype(str)

        sql = "SELECT Id, AccountNo FROM Account;"
        accounts = Util.execute_query(sql)
        accounts["AccountNo"] = accounts["AccountNo"].astype(str)
        merge = pd.merge(rad_account, accounts, on="AccountNo")
        merge = merge[["RADTypeId", "Id"]]
        merge = merge.rename(columns={"RADTypeId": "RadTypeId", "Id": "AccountId"})
        merge.dropna(inplace=True)

        table = "Account_RadType"
        Util.import_func(merge, table)

    def _import_budget_rad(self):
        try:
            raw = pd.read_csv(r"./source/budget.csv")
            logging.info("Budget RAD data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Budget RAD CSV: {e}")
            return

        df = raw.copy()
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df_split = df.copy()
        cols = [
            col for col in df_split.columns if "RAD" in col and "Description" not in col
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
        df_result = df_split[["Id", "value"]].reset_index(drop=True)
        df_result.replace("", float("NaN"), inplace=True)
        df_result.dropna(inplace=True)
        df_result.rename(columns={"value": "RADId", "Id": "BudgetId"}, inplace=True)

        table = "Budget_Rad"
        Util.import_func(df_result, table)

    def _import_budget(self):
        try:
            raw = pd.read_csv(r"./source/Budget.csv")
            logging.info("Budget data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Budget CSV: {e}")
            return

        df = raw.copy()
        df.columns = df.columns.str.replace(" ", "")
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df = df.rename(columns={"BudgetId": "FiscalYear", "AccountNo.": "AccountNo"})
        df = df[["Id", "FiscalYear", "BusinessUnitId", "AccountNo", "Amount"]]
        df["AccountNo"] = df["AccountNo"].astype(str).str.replace(".0", "")
        df["Amount"] = df["Amount"].str.replace(",", "").fillna(0).astype(float)

        table = "Budget"
        Util.import_func(df, table)

    def _import_journal_entry_rad(self):
        try:
            raw = pd.read_csv(r"./source/JournalEntry.csv")
            logging.info("Journal Entry read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Journal Entry CSV: {e}")
            return

        df = raw.copy()
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df = raw.copy()
        df.columns = df.columns.str.replace(" ", "")
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df["AccountingDate"] = pd.to_datetime(
            df["AccountingDate"], format="%m/%d/%Y", errors="coerce"
        )
        df["FiscalYear"] = df["AccountingDate"].apply(Util.get_fiscal_year)
        je = df[
            [
                "Id",
                "FiscalYear",
                "CompanyId",
                "EntryId",
                "BusinessUnitId",
                "AccountNo",
                "Amount",
                "AccountingDate",
                "Remarks",
            ]
        ].copy()
        je["EntryId"] = je["EntryId"].fillna(0).astype(int)
        je["AccountNo"] = (
            je["AccountNo"].fillna(0).astype(str).replace(r"\.0$", "", regex=True)
        )
        je["BusinessUnitId"] = (
            je["BusinessUnitId"].fillna(0).astype(str).replace(r"\.0$", "", regex=True)
        )
        je["CompanyId"] = (
            je["CompanyId"].fillna(0).astype(str).replace(r"\.0$", "", regex=True)
        )
        je["Amount"] = je["Amount"].str.replace(",", "").fillna(0).astype(float)
        
        table = "JournalEntry"
        Util.import_func(je, table)

    def _import_journal_entry(self):
        try:
            raw = pd.read_csv(r"./source/JournalEntry.csv")
            logging.info("Journal Entry read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Journal Entry CSV: {e}")
            return

        df = raw.copy()
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df = raw.copy()
        df.columns = df.columns.str.replace(" ", "")
        df = df.reset_index(drop=True)
        df["Id"] = df.index + 1
        df["AccountingDate"] = pd.to_datetime(
            df["AccountingDate"], format="%m/%d/%Y", errors="coerce"
        )
        df["FiscalYear"] = df["AccountingDate"].apply(Util.get_fiscal_year)
        df_split = df.copy()
        cols = [
            col for col in df_split.columns if "RAD" in col and "Description" not in col
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
        df_result = df_split[["Id", "value"]].reset_index(drop=True)
        df_result.replace("", float("NaN"), inplace=True)
        df_result.dropna(inplace=True)
        df_result.rename(
            columns={"value": "RADId", "Id": "JournalEntryId"}, inplace=True
        )

        table = "JournalEntry_Rad"
        Util.import_func(df_result, table)

    def _import_rad(self):
        try:
            raw = pd.read_csv(r"./source/Rad.csv")
            logging.info("RAD data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading RAD CSV: {e}")
            return

        rad = raw.copy()
        rad = rad[['RADTypeId', 'RADId', 'RAD']]
        
        table = "Rad"
        Util.import_func(rad, table)

    def _import_rad_type(self):
        try:
            raw = pd.read_csv(r"./source/Rad.csv")
            logging.info("RAD data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading RAD CSV: {e}")
            return

        rad = raw.copy()
        rad = rad[['RADTypeId', 'RADType']]
        rad = rad.drop_duplicates()
        
        table = "RadType"
        Util.import_func(rad, table)

    def _import_business_unit(self):
        try:
            raw = pd.read_csv(r"./source/BusinessUnit.csv")
            logging.info("Business Unit data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Business Unit CSV: {e}")
            return
        
        df = raw.copy()
        df = df.reset_index(drop=True)
        df.columns = df.columns.str.replace(' ', "")
        df['Id'] = df.index + 1
        df = df[['Id', 'BusinessUnitId', 'BusinessUnit', 'CompanyId', 'Company', 'DateCreated']]
        df['DateCreated'] = pd.to_datetime(df['DateCreated'], format='%m/%d/%Y').dt.strftime('%Y-%m-%d %H:%M:%S')
        
        table = "BusinessUnit"
        Util.import_func(df, table)

    def import_budget_entry_admin_view(self):
        try:
            raw = pd.read_csv(r"./source/BudgetEntryAdminView.csv")
            logging.info("Budget Entry Admin View data read from CSV.")
        except Exception as e:
            logging.exception(f"Error reading Budget Entry Admin View CSV: {e}")
            return
        
        df = raw.copy()
        df = df.reset_index(drop=True)
        df.columns = df.columns.str.replace(' ', "")
        df['Id'] = df.index + 1
        
        table = "BudgetEntryAdminView"
        Util.import_func(df, table)

class Util:
    @staticmethod
    def import_func(df: pd.DataFrame(), table: str) -> None:
        try:
            conn = DBManager().connect()
            cursor = conn.cursor()
            cursor.execute(f"DELETE FROM {table}")
            conn.commit()
            df.to_sql(table, conn, if_exists="append", index=False)
            logging.info(f"Data imported into {table} successfully.")
        except Exception as error:
            logging.exception(f"Error importing data into {table}: {error}")
            raise error
        finally:
            cursor.close()
            conn.close()
            logging.info("Database connection closed.")

    @staticmethod
    def execute_query(sql: str) -> pd.DataFrame() | None:
        try:
            conn = DBManager().connect()
            df = pd.read_sql(sql, conn)
            logging.info(f"Data from query:\n{sql}\n successful.")
            return df
        except Exception as error:
            logging.exception(f"Error from query:\n{sql}\n {error}")
            raise error
        finally:
            conn.close()
            logging.info("Database connection closed.")

    @staticmethod
    def get_fiscal_year(date):
        if pd.isna(date):
            return "UnkownFiscalYear"

        year = date.year

        # Define fiscal year start and end based on the current year
        fiscal_start = pd.Timestamp(f"{year-1}-10-01")
        fiscal_end = pd.Timestamp(f"{year}-09-30")

        # If date is between October 1st of the previous year and September 30th of the current year
        if fiscal_start <= date <= fiscal_end:
            return f"FY{str(year)[-2:]}"  # Current year as fiscal year
        else:
            return f"FY{str(year + 1)[-2:]}"  # Next year as fiscal year


if __name__ == "__main__":
    try:
        migration = Migration()
        migration.create_database()
        migration.import_all()
    except Exception as error:
        raise error
