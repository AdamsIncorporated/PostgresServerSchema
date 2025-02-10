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
    account_no TEXT,
    business_unit_id TEXT,
    rad_data JSONB NULL,
    amount DECIMAL(20, 2),
    accounting_date DATE,
    date_posted DATE,
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

CREATE INDEX idx_journal_entry_account_no_business_unit_id_accounting_date
ON multiview.journal_entry (account_no, business_unit_id, accounting_date);


CREATE TABLE multiview.budget (
    id SERIAL PRIMARY KEY,
    budget_id TEXT,
    account_no TEXT,
    business_unit_id TEXT,
    rad_data JSONB NULL,
    amount DECIMAL(20, 2),
    accounting_date DATE,
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

CREATE TABLE multiview.report_template (
    id SERIAL PRIMARY KEY,
    report_name TEXT UNIQUE,
    report_structure JSONB
);

CREATE VIEW multiview.vw_flat_budget AS (
    SELECT
        b.id,
        a.id AS account_id,
        a.account_no,
        a.account,
        a.account_type,
        bu.id AS table_business_unit_id,
        bu.business_unit_id,
        bu.business_unit,
        b.rad_data,
        b.amount,
        b.budget_id,
        b.accounting_date,
        b.fiscal_year
    FROM multiview.budget b
        left join multiview.account a on a.account_no = b.account_no
        left join multiview.business_unit bu on bu.business_unit_id = b.business_unit_id
    ORDER BY b.accounting_date, b.id
);

CREATE VIEW multiview.vw_flat_journal_entry AS (
    SELECT
        j.id,
        a.id AS account_id,
        a.account_no,
        a.account,
        a.account_type,
        bu.id AS table_business_unit_id,
        bu.business_unit_id,
        bu.business_unit,
        j.rad_data,
        j.amount,
        j.entry_id,
        j.accounting_date,
        j.date_posted,
        j.fiscal_year
    FROM multiview.journal_entry j
        left join multiview.account a on a.account_no = j.account_no
        left join multiview.business_unit bu on bu.business_unit_id = j.business_unit_id
    ORDER BY j.accounting_date, j.id
);