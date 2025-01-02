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
    CONSTRAINT unqiue_account_no_parent_account_no UNIQUE (account_no, parent_account_no),
    FOREIGN KEY (account_no) REFERENCES multiview.account (account_no)
);

CREATE TABLE multiview.rad (
    id SERIAL PRIMARY KEY,
    rad_type_id TEXT,
    rad_id TEXT,
    CONSTRAINT unique_rad_id_rad_type_id UNIQUE (rad_id, rad_type_id)
);

CREATE TABLE multiview.journal_entry (
    id SERIAL PRIMARY KEY,
    entry_id TEXT,
    business_unit_id TEXT,
    account_no TEXT,
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
    budget_id TEXT,
    business_unit_id TEXT,
    account_no TEXT,
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

CREATE VIEW vw_flat_budget AS (
    SELECT
        b.id,
        a.id AS account_id,
        a.account_no,
        a.account,
        a.account_type,
        bu.id AS table_business_unit_id,
        bu.business_unit_id,
        bu.business_unit,
        br.id AS budget_rad_id,
        br.rad_type_id,
        br.rad_id,
        b.amount,
        b.budget_id,
        b.accounting_date,
        b.fiscal_year
    FROM 
        multiview.budget b
        join multiview.budget_rad br on b.id = br.table_budget_id
        join multiview.account a on a.account_no = b.account_no
        join multiview.business_unit bu on bu.business_unit_id = b.business_unit_id
    ORDER BY b.accounting_date, b.id
);

CREATE VIEW vw_flat_journal_entry AS (
    SELECT
        j.id,
        a.id AS account_id,
        a.account_no,
        a.account,
        a.account_type,
        bu.id AS table_business_unit_id,
        bu.business_unit_id,
        bu.business_unit,
        jr.id AS journal_rad_id,
        jr.rad_type_id,
        jr.rad_id,
        j.amount,
        j.entry_id,
        j.accounting_date,
        j.fiscal_year
    FROM 
        multiview.journal_entry j
        join multiview.journal_entry_rad jr on j.id = jr.journal_entry_id
        join multiview.account a on a.account_no = j.account_no
        join multiview.business_unit bu on bu.business_unit_id = j.business_unit_id
    ORDER BY j.accounting_date, j.id
);
