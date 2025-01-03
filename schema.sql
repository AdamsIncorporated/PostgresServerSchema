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
        br.id AS budget_rad_id,
        br.rad_type_id,
        br.rad_id,
        b.amount,
        b.budget_id,
        b.accounting_date,
        b.fiscal_year
    FROM multiview.budget b
        join multiview.budget_rad br on b.id = br.table_budget_id
        join multiview.account a on a.account_no = b.account_no
        join multiview.business_unit bu on bu.business_unit_id = b.business_unit_id
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
        jr.id AS journal_rad_id,
        jr.rad_type_id,
        jr.rad_id,
        j.amount,
        j.entry_id,
        j.accounting_date,
        j.fiscal_year
    FROM multiview.journal_entry j
        join multiview.journal_entry_rad jr on j.id = jr.journal_entry_id
        join multiview.account a on a.account_no = j.account_no
        join multiview.business_unit bu on bu.business_unit_id = j.business_unit_id
    ORDER BY j.accounting_date, j.id
);

CREATE OR REPLACE FUNCTION multiview.get_account_hierarchy(account_no TEXT)
RETURNS TABLE 
(
    "is_input_id_root" BOOLEAN,
    "id" INT, 
    "parent" TEXT, 
    "child" TEXT
) 
AS $$
BEGIN
    RETURN QUERY (
        WITH RECURSIVE
        child_hierarchy AS (
            SELECT 
                FALSE as is_input_id_root,
                x.id, 
                x.account_no as child, 
                x.parent_account_no as parent
            FROM multiview.account_ownership x 
            WHERE
                parent_account_no = $1
            UNION ALL
            SELECT 
                FALSE as is_input_id_root,
                y.id, 
                y.account_no as child, 
                y.parent_account_no as parent
            FROM multiview.account_ownership y
            JOIN child_hierarchy ch ON y.parent_account_no = ch.child
        )
        SELECT 
            z.is_input_id_root, 
            z.id, 
            z.parent, 
            z.child
        FROM child_hierarchy z
    );

    IF NOT FOUND THEN
    RETURN QUERY (
        SELECT 
            TRUE as is_input_id_root,
            not_found.id, 
            not_found.parent_account_no as parent,
            not_found.account_no as child
        FROM multiview.account_ownership not_found 
        WHERE not_found.account_no = $1
    );
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.get_business_unit_hierarchy(business_unit_id TEXT)
RETURNS TABLE 
(
    "is_input_id_root" BOOLEAN,
    "id" INT, 
    "parent" TEXT, 
    "child" TEXT
) 
AS $$
BEGIN
    RETURN QUERY (
        WITH RECURSIVE
        child_hierarchy AS (
            SELECT
                FALSE as is_input_id_root, 
                x.id, 
                x.business_unit_id as child, 
                x.parent_business_unit_id as parent
            FROM multiview.business_unit_ownership x 
            WHERE
                x.parent_business_unit_id = $1
            UNION ALL
            SELECT 
                FALSE as is_input_id_root,
                y.id, 
                y.business_unit_id as child, 
                y.parent_business_unit_id as parent
            FROM multiview.business_unit_ownership y
            JOIN child_hierarchy ch ON y.parent_business_unit_id = ch.child
        )
        SELECT 
            z.is_input_id_root,
            z.id, 
            z.parent, 
            z.child
        FROM child_hierarchy z
    );

    IF NOT FOUND THEN
    RETURN QUERY (
        SELECT 
            TRUE as is_input_id_root,
            not_found.id, 
            not_found.parent_business_unit_id as parent,
            not_found.business_unit_id as child
        FROM multiview.business_unit_ownership not_found 
        WHERE not_found.business_unit_id = $1
    );
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.get_rad_hierarchy(rad_id TEXT)
RETURNS TABLE 
(
    "is_input_id_root" BOOLEAN,
    "id" INT, 
    "parent" TEXT, 
    "child" TEXT
) 
AS $$
BEGIN
    RETURN QUERY (
        WITH RECURSIVE
        child_hierarchy AS (
            SELECT 
                FALSE as is_input_id_root,
                x.id, 
                x.rad_id as child, 
                x.rad_type_id as parent
            FROM multiview.rad x 
            WHERE
                x.rad_type_id = $1
            UNION ALL
            SELECT 
                FALSE as is_input_id_root,
                y.id, 
                y.rad_id as child, 
                y.rad_type_id as parent
            FROM multiview.rad y
            JOIN child_hierarchy ch ON y.rad_type_id = ch.child
        )
        SELECT 
            z.is_input_id_root,
            z.id, 
            z.parent, 
            z.child
        FROM child_hierarchy z
    );

    IF NOT FOUND THEN
    RETURN QUERY (
        SELECT 
            TRUE as is_input_id_root,
            not_found.id, 
            not_found.rad_type_id as parent,
            not_found.rad_id as child
        FROM multiview.rad not_found 
        WHERE not_found.rad_id = $1
    );
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.get_fiscal_year(input_date DATE)
RETURNS INTEGER AS $$
DECLARE
    fiscal_year INTEGER;
BEGIN
    -- Determine fiscal year based on September 30th as the end of the fiscal year
    IF extract(month from input_date) >= 10 THEN
        fiscal_year := extract(year from input_date);
    ELSE
        fiscal_year := extract(year from input_date) - 1;
    END IF;

    RETURN fiscal_year;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION multiview.get_line_item(
    anchor_date DATE,
    account_nos TEXT[],
    business_unit_ids TEXT[],
    rad_ids TEXT[]
)
RETURNS TABLE 
(
    "order" INT,
    "label" TEXT,
    "start_date" DATE,
    "end_date" DATE,
    "sum" REAL
) 
AS $$
BEGIN
    RETURN QUERY (
        -- Current Month Actual
        SELECT 
            1 as "order",
            'current_month_total' AS "label",
            DATE_TRUNC('month', $1)::DATE AS "start_date",
            (DATE_TRUNC('month', $1) + INTERVAL '1 month' - INTERVAL '1 day')::DATE AS "end_date",
            SUM(actual.Amount) AS "sum"
        FROM multiview.vw_flat_journal_entry actual
        WHERE
            actual.Amount IS NOT NULL
            AND actual.fiscal_year = multiview.get_fiscal_year($1)
            AND EXTRACT(MONTH FROM actual.accounting_date) = EXTRACT(MONTH FROM $1)
            AND actual.account_no = ANY($2)
            AND actual.business_unit_id = ANY($3)
            AND actual.rad_id = ANY($4)
        
        UNION

        -- Current Year To Date Actual
        SELECT 
            2 as "order",
            'current_year_to_date' AS "label",
            TO_DATE(CONCAT(multiview.get_fiscal_year($1), '-10-01'), 'YYYY-MM-DD') AS "start_date",
            $1 AS "end_date",
            SUM(actual.Amount) AS "sum"
        FROM multiview.vw_flat_journal_entry actual
        WHERE
            actual.Amount IS NOT NULL
            AND actual.accounting_date 
                BETWEEN
                    TO_DATE(CONCAT(multiview.get_fiscal_year($1), '-10-01'), 'YYYY-MM-DD')
                    AND $1
        
        UNION

        -- Current Fiscal Year Budget
        SELECT 
            3 as "order",
            'current_fiscal_year_budget' AS "label",
            TO_DATE(CONCAT(multiview.get_fiscal_year($1), '-10-01'), 'YYYY-MM-DD') AS "start_date",
            TO_DATE(CONCAT(multiview.get_fiscal_year($1) + 1, '-9-30'), 'YYYY-MM-DD') AS "end_date",
            SUM(budget.Amount) AS "sum"
        FROM multiview.vw_flat_budget budget
        WHERE
            budget.Amount IS NOT NULL
            AND budget.fiscal_year = multiview.get_fiscal_year($1)
        
        UNION

        -- Current Year To Date Actual
        SELECT 
            4 as "order",
            'prior_year_to_date' AS "label",
            TO_DATE(CONCAT(multiview.get_fiscal_year($1) - 1, '-10-01'), 'YYYY-MM-DD') AS "start_date",
            ($1 - INTERVAL '1 year')::DATE AS "end_date",
            SUM(actual.Amount) AS "sum"
        FROM multiview.vw_flat_journal_entry actual
        WHERE
            actual.Amount IS NOT NULL
            AND actual.accounting_date 
                BETWEEN
                    TO_DATE(CONCAT(multiview.get_fiscal_year($1) - 1, '-10-01'), 'YYYY-MM-DD')
                    AND ($1 - INTERVAL '1 year')::DATE
               
    );
END;
$$ LANGUAGE plpgsql;

SELECT * 
FROM multiview.get_line_item(
    anchor_date => '2024-10-31'::DATE,
    account_nos => ARRAY['45700'],
    business_unit_ids => '{}',
    rad_ids => '{}'
);