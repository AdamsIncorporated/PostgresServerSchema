-- Active: 1732559110932@@127.0.0.1@5432@central_health@public
DROP SCHEMA IF EXISTS multiview CASCADE;

CREATE SCHEMA multiview;

CREATE TABLE multiview.business_unit (
    id SERIAL PRIMARY KEY,
    business_unit_id TEXT UNIQUE,
    business_unit TEXT,
    CONSTRAINT unique_business_unit_id_business_unit UNIQUE (
        business_unit_id,
        business_unit
    )
);

CREATE TABLE multiview.business_unit_ownership (
    id SERIAL PRIMARY KEY,
    business_unit_id TEXT UNIQUE,
    parent_business_unit_id TEXT,
    CONSTRAINT unqiue_business_unit_id_parent_business_unit_id UNIQUE (
        business_unit_id,
        parent_business_unit_id
    ),
    FOREIGN KEY (business_unit_id) REFERENCES multiview.business_unit (business_unit_id)
);

CREATE TABLE multiview.account (
    id SERIAL PRIMARY KEY,
    account_no TEXT UNIQUE,
    account TEXT,
    account_type TEXT,
    CONSTRAINT unique_account_no_account UNIQUE (account_no, account)
);

CREATE TABLE multiview.account_ownership (
    id SERIAL PRIMARY KEY,
    account_no TEXT UNIQUE,
    parent_account_no TEXT,
    CONSTRAINT unqiue_account_no_parent_account_no UNIQUE (
        account_no,
        parent_account_no
    ),
    FOREIGN KEY (account_no) REFERENCES multiview.account (account_no)
);

CREATE TABLE multiview.rad (
    id SERIAL PRIMARY KEY,
    rad_type_id TEXT UNIQUE,
    rad_id TEXT,
    rad TEXT,
    CONSTRAINT unique_rad_id_rad_type_id UNIQUE (rad_id, rad_type_id) 
);

CREATE TABLE multiview.journal_entry (
    id SERIAL PRIMARY KEY,
    detail_id INT UNIQUE,
    entry_id TEXT,
    business_unit_id TEXT,
    account_no TEXT,
    account TEXT,
    amount REAL,
    accounting_date TIMESTAMP,
    fiscal_year INT GENERATED ALWAYS AS (
        CASE
            WHEN EXTRACT(
                MONTH
                FROM accounting_date
            ) >= 10 THEN EXTRACT(
                YEAR
                FROM accounting_date
            ) + 1
            ELSE EXTRACT(
                YEAR
                FROM accounting_date
            )
        END
    ) STORED,
    FOREIGN KEY (business_unit_id) REFERENCES multiview.business_unit (business_unit_id),
    FOREIGN KEY (account_no) REFERENCES multiview.account (account_no)
);

CREATE TABLE multiview.budget (
    id SERIAL PRIMARY KEY,
    detail_id INT UNIQUE,
    budget_id TEXT,
    business_unit_id TEXT,
    account_no TEXT,
    account TEXT,
    amount REAL,
    accounting_date TIMESTAMP,
    fiscal_year INT GENERATED ALWAYS AS (
        CASE
            WHEN EXTRACT(
                MONTH
                FROM accounting_date
            ) >= 10 THEN EXTRACT(
                YEAR
                FROM accounting_date
            ) + 1
            ELSE EXTRACT(
                YEAR
                FROM accounting_date
            )
        END
    ) STORED,
    FOREIGN KEY (account_no) REFERENCES multiview.account (account_no),
    FOREIGN KEY (business_unit_id) REFERENCES multiview.business_unit (business_unit_id)
);

CREATE TABLE multiview.journal_entry_rad (
    id SERIAL PRIMARY KEY,
    journal_entry_id INTEGER,
    rad_type_id TEXT,
    rad_id TEXT,
    FOREIGN KEY (journal_entry_id) REFERENCES multiview.journal_entry (id),
    FOREIGN KEY (rad_id, rad_type_id) REFERENCES multiview.rad (rad_id, rad_type_id)
);

CREATE TABLE multiview.budget_rad (
    id SERIAL PRIMARY KEY,
    table_budget_id INTEGER,
    rad_type_id TEXT,
    rad_id TEXT,
    FOREIGN KEY (table_budget_id) REFERENCES multiview.budget (id),
    FOREIGN KEY (rad_id, rad_type_id) REFERENCES multiview.rad (rad_id, rad_type_id)
);