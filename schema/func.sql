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
    "account_arr" TEXT[],
    "business_unit_id_arr" TEXT[],
    "rad_arr" JSONB,
    "CurrentMonthActual" DECIMAL(20, 2),
    "CurrentYearToDate" DECIMAL(20, 2),
    "CurrentYearBudget" DECIMAL(20, 2),
    "PriorYearToDate" DECIMAL(20, 2)
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
                account_list as account_arr,
                business_unit_list as business_unit_id_arr,
                rad_json as rad_arr,
                SUM(CASE WHEN accounting_date BETWEEN target_beginning_of_month_date AND target_date THEN amount ELSE 0 END)::DECIMAL(20, 2) AS CurrentMonthActual,
                SUM(CASE WHEN accounting_date BETWEEN current_fiscal_year_start_date AND target_date THEN amount ELSE 0 END)::DECIMAL(20, 2) AS CurrentYearToDate,
                (SELECT SUM(amount) FROM budget_slice)::DECIMAL(20, 2) AS CurrentYearBudget,
                SUM(CASE WHEN accounting_date BETWEEN prior_fiscal_year_start_date AND prior_fiscal_year_end_date THEN amount ELSE 0 END)::DECIMAL(20, 2) AS PriorYearToDate
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
    "amount" DECIMAL(20, 2),
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


CREATE OR REPLACE FUNCTION multiview.trial_balance_journal_entry(start_date DATE, end_date DATE)
RETURNS TABLE (
    "account_no" TEXT,
    "business_unit_id" TEXT,
    "opening_balance" DECIMAL(20, 2),
    "activity_balance" DECIMAL(20, 2),
    "closing_balance" DECIMAL(20, 2),
    "transaction_count" BIGINT
) 
AS $$
BEGIN
    RETURN QUERY
    WITH aggregated AS (
        SELECT
            j.account_no,
            j.business_unit_id,
            SUM(CASE WHEN j.accounting_date < start_date THEN j.amount ELSE 0 END)::DECIMAL(20,2) AS opening_balance,
            SUM(CASE WHEN j.accounting_date BETWEEN start_date AND end_date THEN j.amount ELSE 0 END)::DECIMAL(20,2) AS activity_balance,
            SUM(j.amount)::DECIMAL(20,2) AS closing_balance,
            COUNT(*) FILTER (WHERE j.accounting_date BETWEEN start_date AND end_date) AS transaction_count
        FROM multiview.journal_entry j
        WHERE j.accounting_date <= end_date
        GROUP BY j.account_no, j.business_unit_id
    )
    SELECT 
        a.account_no,
        a.business_unit_id,
        a.opening_balance,
        a.activity_balance,
        a.closing_balance,
        a.transaction_count
    FROM aggregated a 
    WHERE NOT (
        a.closing_balance = 0 
        AND a.opening_balance = 0 
        AND a.transaction_count = 0
    )
    ORDER BY account_no, business_unit_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.trial_balance_by_rad_journal_entry(start_date DATE, end_date DATE)
RETURNS TABLE (
    "account_no" TEXT,
    "business_unit_id" TEXT,
    "rad_data" JSONB,
    "opening_balance" DECIMAL(20, 2),
    "activity_balance" DECIMAL(20, 2),
    "closing_balance" DECIMAL(20, 2),
    "transaction_count" BIGINT
)
AS $$
BEGIN
    RETURN QUERY
    WITH aggregated_data AS (
        SELECT
            j.account_no,
            j.business_unit_id,
            j.rad_data,
            SUM(CASE WHEN j.accounting_date < start_date THEN j.amount ELSE 0 END) AS opening_balance,
            SUM(CASE WHEN j.accounting_date BETWEEN start_date AND end_date THEN j.amount ELSE 0 END) AS activity_balance,
            SUM(CASE WHEN j.accounting_date <= end_date THEN j.amount ELSE 0 END) AS closing_balance,
            COUNT(*) FILTER (WHERE j.accounting_date BETWEEN start_date AND end_date) AS transaction_count
        FROM multiview.journal_entry j
        WHERE j.accounting_date <= end_date
        GROUP BY j.account_no, j.business_unit_id, j.rad_data
    )
    SELECT 
        ad.account_no,
        ad.business_unit_id,
        ad.rad_data,
        COALESCE(ad.opening_balance, 0)::DECIMAL(20, 2),
        COALESCE(ad.activity_balance, 0)::DECIMAL(20, 2),
        COALESCE(ad.closing_balance, 0)::DECIMAL(20, 2),
        COALESCE(ad.transaction_count, 0)::BIGINT
    FROM aggregated_data ad
    WHERE 
        NOT (ad.closing_balance = 0 AND ad.opening_balance = 0 AND ad.transaction_count = 0)
    ORDER BY ad.account_no, ad.business_unit_id;
END $$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION multiview.trial_balance_summary(anchor_date DATE)
RETURNS TABLE (
    account_no TEXT,
    account TEXT,
    account_type TEXT,
    business_unit_id TEXT,
    business_unit TEXT,
    rad_data JSONB,
    opening_balance NUMERIC,
    activity_balance NUMERIC,
    closing_balance NUMERIC,
    transaction_count BIGINT,
    time_period TEXT,
    consumption TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        master.account_no::TEXT,
        a."account"::TEXT,
        a.account_type::TEXT,
        master.business_unit_id::TEXT,
        b.business_unit::TEXT,
        master.rad_data::JSONB,
        master.opening_balance::NUMERIC,
        master.activity_balance::NUMERIC,
        master.closing_balance::NUMERIC,
        master.transaction_count::BIGINT,
        master.time_period::TEXT,
        ''::TEXT AS consumption
    FROM (
        -- Current Month
        SELECT 
            je.account_no::TEXT, 
            je.business_unit_id::TEXT,
            je.rad_data::JSONB,
            je.opening_balance::NUMERIC, 
            je.activity_balance::NUMERIC, 
            je.closing_balance::NUMERIC, 
            je.transaction_count::BIGINT, 
            'CurrentMonth' AS time_period
        FROM multiview.trial_balance_by_rad_journal_entry(
            start_date := DATE_TRUNC('month', anchor_date)::DATE,
            end_date := anchor_date
        ) AS je

        UNION ALL

        -- Current YTD
        SELECT 
            je.account_no::TEXT, 
            je.business_unit_id::TEXT,
            je.rad_data::JSONB,
            je.opening_balance::NUMERIC, 
            je.activity_balance::NUMERIC, 
            je.closing_balance::NUMERIC, 
            je.transaction_count::BIGINT, 
            'CurrentYTD' AS time_period
        FROM multiview.trial_balance_by_rad_journal_entry(
            start_date := (multiview.get_fiscal_year(anchor_date)::TEXT || '-10-01')::DATE,
            end_date := anchor_date
        ) AS je

        UNION ALL

        -- Current FY Budget
        SELECT 
            bgt.account_no::TEXT, 
            bgt.business_unit_id::TEXT,
            bgt.rad_data::JSONB,
            0::NUMERIC as opening_balance, -- there are no balances for budget data
            sum(amount)::NUMERIC as activity_balance, 
            0::NUMERIC as closing_balance,  -- there are no balances for budget data
            count(*) as transaction_count,  
            'CurrentFYBudget' AS time_period
        FROM multiview.budget bgt 
        WHERE 
            bgt.accounting_date >= (multiview.get_fiscal_year(anchor_date)::TEXT || '-10-01')::DATE
            AND bgt.accounting_date <= anchor_date
        GROUP BY
            bgt.account_no::TEXT, 
            bgt.business_unit_id::TEXT,
            bgt.rad_data::JSONB

        UNION ALL

        -- Prior YTD
        SELECT 
            je.account_no::TEXT, 
            je.business_unit_id::TEXT,
            je.rad_data::JSONB, 
            je.opening_balance::NUMERIC, 
            je.activity_balance::NUMERIC, 
            je.closing_balance::NUMERIC, 
            je.transaction_count::BIGINT, 
            'PriorYTD' AS time_period
        FROM multiview.trial_balance_by_rad_journal_entry(
            start_date := ((multiview.get_fiscal_year(anchor_date) - 1)::TEXT || '-10-01')::DATE,
            end_date := (anchor_date - INTERVAL '1 year')::DATE
        ) AS je

    ) AS master
    JOIN multiview."account" a ON master.account_no = a.account_no
    JOIN multiview.business_unit b ON master.business_unit_id = b.business_unit_id;
END;
$$ LANGUAGE plpgsql;