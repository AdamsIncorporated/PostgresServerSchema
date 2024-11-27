-- Active: 1732559110932@@127.0.0.1@5432@central_health
CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    username TEXT UNIQUE NOT NULL,
    email TEXT UNIQUE NOT NULL,
    password TEXT NOT NULL,
    image_file BYTEA,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    date_created TEXT,
    is_root_user BOOLEAN NOT NULL DEFAULT FALSE CHECK (is_root_user IN (FALSE, TRUE))
);

CREATE TABLE business_unit (
    id SERIAL PRIMARY KEY,
    company_id TEXT,
    business_unit_id TEXT UNIQUE,
    business_unit TEXT,
    company TEXT,
    date_created TIMESTAMP
);

ALTER TABLE business_unit
ADD CONSTRAINT unique_business_unit_id_business_unit_company_id UNIQUE (
    company_id,
    business_unit_id,
    business_unit
);

CREATE TABLE user_business_unit (
    id SERIAL PRIMARY KEY,
    company_id TEXT,
    business_unit_id TEXT NOT NULL,
    business_unit TEXT NULL,
    user_id INTEGER NOT NULL,
    FOREIGN KEY (
        company_id,
        business_unit_id,
        business_unit
    ) REFERENCES business_unit (
        company_id,
        business_unit_id,
        business_unit
    ),
    FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE account (
    id SERIAL PRIMARY KEY,
    parent_account_no TEXT,
    chart_id INTEGER,
    account_no TEXT UNIQUE,
    account TEXT,
    account_type TEXT,
    drcr TEXT,
    posting_level TEXT,
    inter_company_flag TEXT,
    security_status TEXT,
    account_control_class TEXT,
    class_description TEXT,
    user_created TEXT,
    date_created TIMESTAMP,
    CONSTRAINT unique_account_no_account UNIQUE (account_no, account)
);

CREATE TABLE rad_type (
    id SERIAL PRIMARY KEY,
    rad_type_id TEXT UNIQUE,
    rad_type TEXT UNIQUE
);

CREATE TABLE rad (
    id SERIAL PRIMARY KEY,
    rad_type_id TEXT,
    rad_id TEXT,
    rad TEXT,
    FOREIGN KEY (rad_type_id) REFERENCES rad_type (rad_type_id),
    CONSTRAINT unique_rad_id_rad UNIQUE (rad_type_id, rad_id, rad)
);

CREATE TABLE account_rad_type (
    id SERIAL PRIMARY KEY,
    account_id INTEGER UNIQUE,
    rad_type_id TEXT,
    FOREIGN KEY (account_id) REFERENCES account (id),
    FOREIGN KEY (rad_type_id) REFERENCES rad_type (rad_type_id)
);

CREATE TABLE journal_entry (
    id SERIAL PRIMARY KEY,
    company_id TEXT,
    entry_id TEXT,
    business_unit_id TEXT,
    business_unit TEXT,
    account_no TEXT,
    account TEXT,
    amount REAL,
    accounting_date TIMESTAMP,
    remarks TEXT,
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
    FOREIGN KEY (
        company_id,
        business_unit_id,
        business_unit
    ) REFERENCES business_unit (
        company_id,
        business_unit_id,
        business_unit
    ),
    FOREIGN KEY (account_no, account) REFERENCES account (account_no, account)
);

CREATE TABLE budget (
    id SERIAL PRIMARY KEY,
    budget_id TEXT,
    company_id TEXT,
    business_unit_id TEXT,
    business_unit TEXT,
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
    FOREIGN KEY (account_no, account) REFERENCES account (account_no, account),
    FOREIGN KEY (
        company_id,
        business_unit_id,
        business_unit
    ) REFERENCES business_unit (
        company_id,
        business_unit_id,
        business_unit
    )
);

CREATE TABLE proposed_budget (
    id SERIAL PRIMARY KEY,
    fiscal_year INTEGER,
    company_id TEXT,
    business_unit_id TEXT,
    business_unit TEXT,
    account_no TEXT,
    rad_type_id TEXT,
    rad_id TEXT,
    rad TEXT,
    proposed_budget REAL,
    business_case_name TEXT,
    business_case_amount REAL,
    total_budget REAL,
    comments TEXT,
    FOREIGN KEY (account_no) REFERENCES account (account_no),
    FOREIGN KEY (company_id, business_unit_id, business_unit) REFERENCES business_unit (company_id, business_unit_id, business_unit),
    FOREIGN KEY (rad_type_id, rad_id, rad) REFERENCES rad (rad_type_id, rad_id, rad)
);

CREATE TABLE journal_entry_rad (
    id SERIAL PRIMARY KEY,
    journal_entry_id INTEGER,
    rad_type_id TEXT,
    rad_id TEXT,
    rad TEXT,
    FOREIGN KEY (journal_entry_id) REFERENCES journal_entry (id),
    FOREIGN KEY (rad_type_id, rad_id, rad) REFERENCES rad (rad_type_id, rad_id, rad)
);

CREATE TABLE budget_rad (
    id SERIAL PRIMARY KEY,
    budget_id INTEGER,
    rad_type_id TEXT,
    rad_id TEXT,
    rad TEXT,
    FOREIGN KEY (budget_id) REFERENCES budget (id),
    FOREIGN KEY (rad_type_id, rad_id, rad) REFERENCES rad (rad_type_id, rad_id, rad)
);

CREATE TABLE budget_entry_admin_view (
    id SERIAL PRIMARY KEY UNIQUE,
    display_order INTEGER UNIQUE NOT NULL,
    account_no TEXT,
    account TEXT,
    rad_type_id TEXT,
    rad_id TEXT,
    rad TEXT,
    forecast_multiplier REAL,
    forecast_comments TEXT,
    FOREIGN KEY (account_no, account) REFERENCES account (account_no, account),
    FOREIGN KEY (rad_type_id, rad_id, rad) REFERENCES rad (rad_type_id, rad_id, rad)
);


CREATE VIEW vw_account_rad_type_rad AS
SELECT
    a.id AS account_table_id,
    a.account,
    a.account_no,
    a.account_type,
    a.chart_id,
    rt.id AS rad_type_table_id,
    rt.rad_type,
    rt.rad_type_id,
    r.id AS rad_table_id,
    r.rad_id,
    r.rad
FROM
    account a
    JOIN account_rad_type art ON art.account_id = a.id
    JOIN rad_type rt ON rt.rad_type_id = art.rad_type_id
    JOIN rad r ON r.rad_type_id = rt.rad_type_id;