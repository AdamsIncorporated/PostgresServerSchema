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
        fiscal_year := extract(year from input_date) + 1;
    ELSE
        fiscal_year := extract(year from input_date);
    END IF;

    RETURN fiscal_year;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.calculate_profit_loss_line(
    target_date DATE,
    target_beginning_of_month_date DATE,
    current_fiscal_year_int INT,
    current_fiscal_year_start_date DATE,
    prior_fiscal_year_start_date DATE,
    prior_fiscal_year_end_date DATE,
    account_list TEXT[] DEFAULT '{}',
    business_unit_list TEXT[] DEFAULT '{}',
    rad_json JSONB DEFAULT '[]'::JSONB
)
RETURNS TABLE (
    "CurrentMonthActual" FLOAT,
    "CurrentYearToDate" FLOAT,
    "CurrentYearBudget" FLOAT,
    "PriorYearToDate" FLOAT
) AS $$
BEGIN
    RETURN QUERY
    WITH
        budget_slice AS (
            SELECT  
                amount
            FROM multiview.budget
            WHERE 
                (array_length(account_list, 1) IS NULL OR account_no = ANY(account_list))
                AND (array_length(business_unit_list, 1) IS NULL OR business_unit_id = ANY(business_unit_list))
                AND fiscal_year = current_fiscal_year_int
                AND (
                    jsonb_array_length(rad_json) = 0
                    OR EXISTS (
                        SELECT 1
                        FROM jsonb_array_elements(rad_data) AS rad_elem
                        JOIN LATERAL jsonb_array_elements(rad_json) AS target_elem ON rad_elem = target_elem
                    )
                )
                AND amount IS NOT NULL
        ),
        actual_slice AS (
            SELECT  
                accounting_date,
                amount
            FROM multiview.journal_entry
            WHERE 
                (array_length(account_list, 1) IS NULL OR account_no = ANY(account_list))
                AND (array_length(business_unit_list, 1) IS NULL OR business_unit_id = ANY(business_unit_list))
                AND (
                    jsonb_array_length(rad_json) = 0
                    OR EXISTS (
                        SELECT 1
                        FROM jsonb_array_elements(rad_data) AS rad_elem
                        JOIN LATERAL jsonb_array_elements(rad_json) AS target_elem ON rad_elem = target_elem
                    )
                )
                AND amount IS NOT NULL
        ),
        agg AS (
            SELECT  
                SUM(CASE WHEN accounting_date BETWEEN target_beginning_of_month_date AND target_date THEN amount ELSE 0 END)::FLOAT AS CurrentMonthActual,
                SUM(CASE WHEN accounting_date BETWEEN current_fiscal_year_start_date AND target_date THEN amount ELSE 0 END) AS CurrentYearToDate,
                (SELECT SUM(amount) FROM budget_slice) AS CurrentYearBudget,
                SUM(CASE WHEN accounting_date BETWEEN prior_fiscal_year_start_date AND prior_fiscal_year_end_date THEN amount ELSE 0 END) AS PriorYearToDate
            FROM actual_slice
        )
    SELECT 
        *
    FROM agg;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION multiview.calculate_profit_loss_line_detail(
    target_date DATE,
    target_beginning_of_month_date DATE,
    current_fiscal_year_int INT,
    current_fiscal_year_start_date DATE,
    prior_fiscal_year_start_date DATE,
    prior_fiscal_year_end_date DATE,
    account_list TEXT[] DEFAULT '{}',
    business_unit_list TEXT[] DEFAULT '{}',
    rad_json JSONB DEFAULT '[]'::JSONB
)
RETURNS TABLE (
    "amount" FLOAT,
    "accounting_date" DATE,
    "fiscal_year" INTEGER,
    "account_no" TEXT,
    "business_unit_id" TEXT,
    "rad_data" JSONB,
    "table_name" TEXT
) AS $$
BEGIN
    RETURN QUERY
    WITH actual_slice AS (
        SELECT  
            j.amount,
            j.accounting_date,
            j.fiscal_year,
            j.account_no,
            j.business_unit_id,
            j.rad_data,
            'journal_entry' AS "table_name"
        FROM multiview.journal_entry j
        WHERE 
            (array_length(account_list, 1) IS NULL OR array_length(account_list, 1) = 0 OR j.account_no = ANY(account_list))
            AND (array_length(business_unit_list, 1) IS NULL OR array_length(business_unit_list, 1) = 0 OR j.business_unit_id = ANY(business_unit_list))
            AND (
                jsonb_array_length(rad_json) = 0
                OR EXISTS (
                    SELECT 1
                    FROM jsonb_array_elements(j.rad_data) AS rad_elem 
                    JOIN LATERAL jsonb_array_elements(rad_json) AS target_elem ON rad_elem = target_elem
                )
            )
    ),
    budget_slice AS (
        SELECT  
            b.amount,
            b.accounting_date,
            b.fiscal_year,
            b.account_no,
            b.business_unit_id,
            b.rad_data,
            'budget_entry' AS "table_name"
        FROM multiview.budget b
        WHERE 
            (array_length(account_list, 1) IS NULL OR array_length(account_list, 1) = 0 OR b.account_no = ANY(account_list))
            AND (array_length(business_unit_list, 1) IS NULL OR array_length(business_unit_list, 1) = 0 OR b.business_unit_id = ANY(business_unit_list))
            AND (
                jsonb_array_length(rad_json) = 0
                OR EXISTS (
                    SELECT 1
                    FROM jsonb_array_elements(b.rad_data) AS rad_elem 
                    JOIN LATERAL jsonb_array_elements(rad_json) AS target_elem ON rad_elem = target_elem
                )
            )
    ),
    combined AS (
        SELECT *
        FROM actual_slice
        UNION ALL
        SELECT *
        FROM budget_slice
    )
    SELECT * FROM combined
    ORDER BY accounting_date DESC;
END;
$$ LANGUAGE plpgsql;
