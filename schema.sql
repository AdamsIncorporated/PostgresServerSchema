CREATE TABLE User (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Username TEXT UNIQUE NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    ImageFile BLOB NULL,
    FirstName TEXT,
    LastName TEXT,
    DateCreated TEXT,
    IsRootUser BLOB NULL
) STRICT;

CREATE TABLE Forecast (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BudgetId TEXT NULL,
    AccountNo TEXT NULL,
    ForecastAmount REAL NULL,
    ForecastFormula TEXT NULL,
    Comments TEXT NULL,
    FOREIGN KEY (BudgetId) REFERENCES Budget (BudgetId),
    FOREIGN KEY (AccountNo) REFERENCES Account (Account)
) STRICT;

CREATE TABLE ProposedBudget (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BusinessUnitId TEXT,
    AccountNo TEXT,
    ProposedBudget REAL,
    BusinessCaseName TEXT,
    BusinessCaseAmount REAL,
    TotalBudget REAL,
    [Comments] TEXT,
    FOREIGN KEY (AccountNo) REFERENCES Account (AccountNo),
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit (BusinessUnitId)
) STRICT;

CREATE TABLE ProposedBusinessUnit (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BusinessUnitId TEXT,
    BusinessUnit TEXT
) STRICT;

CREATE TABLE JournalEntry_Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    JournalEntryId INTEGER,
    RADId TEXT,
    FOREIGN KEY (JournalEntryId) REFERENCES JournalEntry (Id),
    FOREIGN KEY (RADId) REFERENCES RAD (RADId)
) STRICT;

CREATE TABLE Budget_Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BudgetId INTEGER,
    RADId TEXT,
    FOREIGN KEY (BudgetId) REFERENCES Budget (Id),
    FOREIGN KEY (RADId) REFERENCES RAD (RADId)
) STRICT;

CREATE TABLE Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    RADTypeId TEXT,
    RADId TEXT,
    RAD TEXT,
    FOREIGN KEY (RADTypeId) REFERENCES RADType (Id)
) STRICT;

CREATE TABLE RadType (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    RADTypeId TEXT UNIQUE,
    RADType TEXT UNIQUE
) STRICT;

CREATE TABLE "Account_RadType" (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    AccountId INTEGER UNIQUE,
    RadTypeId TEXT,
    FOREIGN KEY (AccountId) REFERENCES Account (Id)
) STRICT;

CREATE TABLE "Account" (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    "ParentAccountNo" TEXT,
    "ChartId" INTEGER,
    "AccountNo" TEXT UNIQUE,
    "Account" TEXT,
    "AccountType" TEXT,
    "DR/CR" TEXT,
    "PostingLevel" TEXT,
    "InterCompanyFlag" TEXT,
    "SecurityStatus" TEXT,
    "Revaluation" TEXT,
    "Reconciliation" TEXT,
    "AccountControlClass" TEXT,
    "ClassDescription" TEXT,
    "ConversionTypeId" TEXT,
    "ConversionTypeDescription" TEXT,
    "UDF1" TEXT,
    "XBRLTag" TEXT,
    "UserCreated" TEXT,
    "DateCreated" TEXT
) STRICT;

CREATE TABLE JournalEntry (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    FiscalYear TEXT,
    CompanyId TEXT,
    EntryId TEXT,
    BusinessUnitId TEXT,
    AccountNo TEXT,
    Amount REAL,
    AccountingDate TEXT,
    Remarks TEXT,
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit (BusinessUnitId),
    FOREIGN KEY (AccountNo) REFERENCES Account (AccountNo),
    FOREIGN KEY (CompanyId) REFERENCES Account (CompanyId)
) STRICT;

CREATE TABLE Budget (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FiscalYear TEXT,
    BusinessUnitId INTEGER,
    AccountNo TEXT,
    Amount REAL,
    FOREIGN KEY (AccountNo) REFERENCES Account (AccountNo),
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit (BusinessUnitId)
) STRICT;

CREATE TABLE BusinessUnit (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    BusinessUnitId TEXT,
    BusinessUnit TEXT,
    CompanyId TEXT,
    Company TEXT,
    DateCreated TEXT
) STRICT;

CREATE TABLE Budget_Account (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
    DisplayOrder INTEGER UNIQUE NOT NULL,
    AccountNo TEXT,
    Account TEXT,
    RAD TEXT,
    CreatedDate TEXT,
    FOREIGN KEY (AccountNo) REFERENCES Account (AccountNo),
    FOREIGN KEY (Account) REFERENCES Account (Account),
    FOREIGN KEY (RAD) REFERENCES RAD (RAD)
) STRICT;

CREATE VIEW vwRad_RadType AS
SELECT 
    rt.Id as RadTypeTableId,
    rt."RADTypeId",
    rt."RADType",
    r."Id" AS RADTableId,
    r."RADId",
    r."RAD"
FROM "Rad" r
    JOIN "RadType" rt ON r."RADTypeId" = rt."RADTypeId";

CREATE VIEW vwJournalEntry_By_Rad AS
SELECT 
    j.Id AS JournalEntryTable,
    j.FiscalYear,
    j.AccountNo,
    j.Amount,
    j.BusinessUnitId,
    r.RadTypeId,
    r.RadType,
    jr.RadId,
    r.RAD
FROM "JournalEntry" j
    JOIN "JournalEntry_Rad" jr ON jr."JournalEntryId" = j.Id
    JOIN "vwRad_RadType" r ON r."RADId" = jr."RADId";

CREATE VIEW vwBudget_By_Rad AS
SELECT 
    b.Id AS BudgetTableId,
    b.FiscalYear,
    b.AccountNo,
    b.BusinessUnitId,
    b.Amount,
    r.RadTypeId,
    r.RadType,
    br.RadId,
    r.RAD
FROM "Budget" b
    JOIN "Budget_Rad" br ON br."BudgetId" = b.Id
    JOIN "vwRad_RadType" r ON r."RADId" = br."RADId";

CREATE VIEW vwAccount_RadType_Rad AS 
SELECT 
  a.Id AS AccountTableId,
  a."Account",
  a."AccountNo",
  a."AccountType",
  a."ChartId",
  rt."Id" AS RadTypeTableId,
  rt."RADType",
  rt."RADTypeId",
  r."Id" AS RadTableId,
  r."RADId",
  r."RAD"
FROM Account a
  JOIN "Account_RadType" art ON art."AccountId" = a.Id
  JOIN "RadType" rt ON rt."RADTypeId" = art."RadTypeId"
  JOIN "Rad" r ON r."RADTypeId" = rt."RADTypeId";