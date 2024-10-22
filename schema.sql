CREATE TABLE User (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Username TEXT UNIQUE NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    Password TEXT NOT NULL,
    ImageFile BLOB NULL,
    FirstName TEXT NOT NULL,
    LastName TEXT NOT NULL,
    DateCreated TEXT,
    IsRootUser INTEGER NOT NULL DEFAULT 0 CHECK (IsRootUser IN (0, 1))
) STRICT;

CREATE TABLE User_BusinessUnit (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BusinessUnitId INTEGER NOT NULL,
    UserId INTEGER NOT NULL,
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit(BusinessUnitId),
    FOREIGN KEY (UserId) REFERENCES User(Id)
) STRICT


CREATE TABLE MasterEmail (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    Email TEXT UNIQUE NOT NULL,
    UserCreatorId INTEGER NOT NULL,
    DateCreated TEXT,
    FOREIGN KEY (UserCreatorId) REFERENCES User(Id)
)

CREATE TABLE ProposedBudget (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FiscalYear TEXT,
    BusinessUnitId TEXT,
    AccountNo TEXT,
    RAD TEXT,
    ProposedBudget REAL,
    BusinessCaseName TEXT,
    BusinessCaseAmount REAL,
    TotalBudget REAL,
    Comments TEXT,
    IsSubTotal INTEGER CHECK (IsSubTotal IN (0, 1)),
    FOREIGN KEY (AccountNo) REFERENCES Account(AccountNo),
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit(BusinessUnitId)
    FOREIGN KEY (RAD) REFERENCES Rad(RAD)
) STRICT;

CREATE TABLE ProposedBusinessUnit (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BusinessUnitId TEXT,
    BusinessUnit TEXT
);

CREATE TABLE JournalEntry_Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    JournalEntryId INTEGER,
    RADId TEXT,
    FOREIGN KEY (JournalEntryId) REFERENCES JournalEntry(Id),
    FOREIGN KEY (RADId) REFERENCES RAD(RADId)
);

CREATE TABLE Budget_Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    BudgetId INTEGER,
    RADId TEXT,
    FOREIGN KEY (BudgetId) REFERENCES Budget(Id),
    FOREIGN KEY (RADId) REFERENCES RAD(RADId)
);

CREATE TABLE Rad (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    RADTypeId TEXT,
    RADId TEXT,
    RAD TEXT,
    FOREIGN KEY (RADTypeId) REFERENCES RADType(Id)
);

CREATE TABLE RadType (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    RADTypeId TEXT UNIQUE,
    RADType TEXT UNIQUE
);

CREATE TABLE "Account_RadType" (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    AccountId INTEGER UNIQUE,
    RadTypeId TEXT,
    FOREIGN KEY (AccountId) REFERENCES Account(Id)
);

CREATE TABLE "Account" (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    ParentAccountNo TEXT,
    ChartId INTEGER,
    AccountNo TEXT UNIQUE,
    Account TEXT,
    AccountType TEXT,
    "DR/CR" TEXT,
    PostingLevel TEXT,
    InterCompanyFlag TEXT,
    SecurityStatus TEXT,
    Revaluation TEXT,
    Reconciliation TEXT,
    AccountControlClass TEXT,
    ClassDescription TEXT,
    ConversionTypeId TEXT,
    ConversionTypeDescription TEXT,
    UDF1 TEXT,
    XBRLTag TEXT,
    UserCreated TEXT,
    DateCreated TEXT
);

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
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit(BusinessUnitId),
    FOREIGN KEY (AccountNo) REFERENCES Account(AccountNo),
    FOREIGN KEY (CompanyId) REFERENCES Account(CompanyId)
);

CREATE TABLE Budget (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    FiscalYear TEXT,
    BusinessUnitId INTEGER,
    AccountNo TEXT,
    Amount REAL,
    FOREIGN KEY (AccountNo) REFERENCES Account(AccountNo),
    FOREIGN KEY (BusinessUnitId) REFERENCES BusinessUnit(BusinessUnitId)
);

CREATE TABLE BusinessUnit (
    Id INTEGER PRIMARY KEY AUTOINCREMENT,
    BusinessUnitId TEXT,
    BusinessUnit TEXT,
    CompanyId TEXT,
    Company TEXT,
    DateCreated TEXT
);

CREATE TABLE BudgetEntryAdminView (
    Id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL UNIQUE,
    DisplayOrder INTEGER UNIQUE NOT NULL,
    AccountNo TEXT,
    Account TEXT,
    RAD TEXT,
    CreatedDate TEXT,
    ForecastMultiplier REAL,
    ForecastComments TEXT,
    UserId INTEGER,
    IsActiveTemplate INTEGER NOT NULL CHECK (IsActiveTemplate IN (0, 1)),
    FOREIGN KEY (AccountNo) REFERENCES Account(AccountNo),
    FOREIGN KEY (Account) REFERENCES Account(Account),
    FOREIGN KEY (RAD) REFERENCES RAD(RAD)
    FOREIGN KEY (UserId) REFERENCES User(Id)
) STRICT;

CREATE VIEW vwAccount_RadType_Rad AS 
SELECT 
  a.Id AS AccountTableId,
  a.Account,
  a.AccountNo,
  a.AccountType,
  a.ChartId,
  rt.Id AS RadTypeTableId,
  rt.RADType,
  rt.RADTypeId,
  r.Id AS RadTableId,
  r.RADId,
  r.RAD
FROM Account a
  JOIN "Account_RadType" art ON art.AccountId = a.Id
  JOIN RadType rt ON rt.RADTypeId = art.RadTypeId
  JOIN Rad r ON r.RADTypeId = rt.RADTypeId;
