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
    rad_list TEXT[] DEFAULT '{}'
    )
RETURNS TABLE (
    CurrentMonthActual REAL,
    CurrentYearToDate REAL,
    CurrentYearBudget REAL,
    PriorYearToDate REAL
) AS $$
BEGIN
    RETURN QUERY
    WITH
        budget_template AS (
            SELECT budget.*
            FROM multiview.vw_flat_budget budget
            WHERE
                budget.Amount IS NOT NULL
                AND (
                    budget.account_no::TEXT = ANY (account_list)
                    OR budget.account_no IS NULL
                )
                AND (
                    budget.business_unit_id::TEXT = ANY (business_unit_list)
                    OR budget.business_unit_id IS NULL
                )
                AND (
                    budget.rad_id::TEXT = ANY (rad_list)
                    OR budget.rad_id IS NULL
                )
        ),
        actual_template AS (
            SELECT actual.*
            FROM multiview.vw_flat_journal_entry actual
            WHERE
                actual.Amount IS NOT NULL
                AND (
                    actual.account_no::TEXT = ANY (account_list)
                    OR actual.account_no IS NULL
                )
                AND (
                    actual.business_unit_id::TEXT = ANY (business_unit_list)
                    OR actual.business_unit_id IS NULL
                )
                AND (
                    actual.rad_id::TEXT = ANY (rad_list)
                    OR actual.rad_id IS NULL
                )
        )
    SELECT 
        (
            (SELECT COALESCE(SUM(amount), 0) 
                FROM actual_template
                WHERE accounting_date = target_date) - 
            (SELECT COALESCE(SUM(amount), 0) 
                FROM actual_template
                WHERE accounting_date = target_beginning_of_month_date)
        ) AS CurrentMonthActual,
        (
            SELECT COALESCE(SUM(amount), 0) 
            FROM actual_template
            WHERE accounting_date 
                BETWEEN current_fiscal_year_start_date
                AND target_date
        ) AS CurrentYearToDate,
        (
            SELECT COALESCE(SUM(amount), 0) 
            FROM budget_template
            WHERE fiscal_year = current_fiscal_year_int
        ) AS CurrentYearBudget,
        (
            SELECT COALESCE(SUM(amount), 0) 
            FROM actual_template
            WHERE accounting_date BETWEEN 
                prior_fiscal_year_start_date
                AND prior_fiscal_year_end_date
        ) AS PriorYearToDate;
END;
$$ LANGUAGE plpgsql;