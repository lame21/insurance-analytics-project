/*
=========================================================
Procedure Name : silver.Load_silver
Purpose        : Loads cleansed and standardized data from
                 the Bronze layer into the Silver layer.

Business Rules
---------------
1. Remove duplicate records.
2. Standardize text values.
3. Clean invalid numeric values.
4. Convert data types.
5. Preserve business keys.
6. Load only new records.

Execution
---------
EXEC silver.Load_silver;

=========================================================
*/

CREATE OR ALTER PROCEDURE silver.Load_silver
AS
BEGIN

    BEGIN TRY

        /*=====================================================
          Load Customers
          - Standardize gender values
          - Remove invalid ages
          - Standardize city names
          - Load only new customers
        =====================================================*/

        INSERT INTO silver.customers
        (
            CustomerID,
            Name,
            Gender,
            Age,
            City
        )

        SELECT
            CustomerID,

            -- Preserve customer name
            Name,

            -- Standardize gender values
            CASE
                WHEN TRIM(Gender) LIKE 'f%' THEN 'Female'
                WHEN TRIM(Gender) LIKE 'm%' THEN 'Male'
                ELSE 'Unknown'
            END AS Gender,

            -- Replace negative ages with NULL
            CASE
                WHEN Age < 0 THEN NULL
                ELSE Age
            END AS Age,

            -- Standardize city names
            CASE
                WHEN TRIM(City) LIKE 'f%' THEN 'Francistown'
                WHEN TRIM(City) LIKE 'g%' THEN 'Gaborone'
                ELSE City
            END AS City

        FROM bronze.customers

        -- Load only customers that do not already exist
        WHERE NOT EXISTS
        (
            SELECT 1
            FROM silver.customers s
            WHERE s.CustomerID = bronze.customers.CustomerID
        );


        /*=====================================================
          Load Policies
          - Standardize product names
          - Remove negative premiums
          - Convert multiple date formats
          - Prevent duplicate policy records
        =====================================================*/

        INSERT INTO silver.policies
        (
            PolicyID,
            CustomerID,
            Product,
            Premium,
            StartDate
        )

        SELECT

            -- Preserve business keys
            PolicyID,
            CustomerID,

            -- Consolidate inconsistent product names
            CASE
                WHEN TRIM(Product) LIKE 'M%' THEN 'Motor'
                WHEN TRIM(Product) LIKE 'C%' THEN 'Motor'
                ELSE Product
            END AS Product,

            -- Convert negative premiums to positive values
            ABS(Premium) AS Premium,

            -- Support multiple source date formats
            COALESCE
            (
                TRY_CAST(TRIM(StartDate) AS DATE),
                TRY_CONVERT(DATE, TRIM(StartDate),103)
            ) AS StartDate

        FROM bronze.policies

        WHERE
            PolicyID IS NOT NULL
            AND CustomerID IS NOT NULL

            -- Prevent duplicate policies
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.policies s
                WHERE s.PolicyID = bronze.policies.PolicyID
            );


        /*=====================================================
          Load Claims
          - Remove negative claim amounts
          - Trim text fields
          - Load only new claims
        =====================================================*/

        INSERT INTO silver.claims
        (
            ClaimID,
            PolicyID,
            ClaimAmount,
            Status,
            Reason
        )

        SELECT

            ClaimID,
            PolicyID,

            -- Store claim amounts as positive values
            ABS(ClaimAmount) AS ClaimAmount,

            -- Remove leading/trailing spaces
            TRIM(Status) AS Status,
            TRIM(Reason) AS Reason

        FROM bronze.claims

        WHERE
            ClaimID IS NOT NULL
            AND PolicyID IS NOT NULL

            -- Skip existing claims
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.claims s
                WHERE s.ClaimID = bronze.claims.ClaimID
            );


        /*=====================================================
          Load Payments
          - Remove negative payment amounts
          - Convert payment date
          - Load only new payments
        =====================================================*/

        INSERT INTO silver.payments
        (
            PaymentID,
            PolicyID,
            Amount,
            PaymentDate
        )

        SELECT

            PaymentID,
            PolicyID,

            -- Ensure payment amount is positive
            ABS(Amount) AS Amount,

            -- Convert payment date to DATE datatype
            TRY_CAST(PaymentDate AS DATE) AS PaymentDate

        FROM bronze.payments

        WHERE
            PaymentID IS NOT NULL
            AND PolicyID IS NOT NULL

            -- Skip duplicate payments
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.payments s
                WHERE s.PaymentID = bronze.payments.PaymentID
            );


        /*=====================================================
          Load Products
          - Standardize product names
          - Validate mandatory fields
          - Prevent duplicate products
        =====================================================*/

        INSERT INTO silver.products
        (
            ProductID,
            ProductName
        )

        SELECT

            -- Preserve business key
            ProductID,

            -- Remove unnecessary spaces
            TRIM(ProductName) AS ProductName

        FROM bronze.products

        WHERE

            -- Mandatory business key
            ProductID IS NOT NULL

            -- Product name cannot be blank
            AND NULLIF(TRIM(ProductName), '') IS NOT NULL

            -- Skip existing products
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.products s
                WHERE s.ProductID = bronze.products.ProductID
            );


        /*=====================================================
          Load Branches
          - Standardize branch and city names
          - Validate mandatory fields
          - Prevent duplicate branches
        =====================================================*/

        INSERT INTO silver.branches
        (
            BranchID,
            BranchName,
            City
        )

        SELECT

            BranchID,

            -- Remove unnecessary spaces
            TRIM(BranchName),

            -- Standardize city values
            TRIM(City)

        FROM bronze.branches

        WHERE

            BranchID IS NOT NULL
            AND NULLIF(TRIM(BranchName), '') IS NOT NULL
            AND NULLIF(TRIM(City), '') IS NOT NULL

            -- Skip existing branches
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.branches s
                WHERE s.BranchID = bronze.branches.BranchID
            );


        /*=====================================================
          Load Agents
          - Standardize agent names
          - Validate foreign key
          - Prevent duplicate agents
        =====================================================*/

        INSERT INTO silver.agents
        (
            AgentID,
            AgentName,
            BranchID
        )

        SELECT

            AgentID,

            -- Remove leading/trailing spaces
            TRIM(AgentName),

            -- Preserve branch relationship
            BranchID

        FROM bronze.agents

        WHERE

            AgentID IS NOT NULL
            AND BranchID IS NOT NULL
            AND NULLIF(TRIM(AgentName), '') IS NOT NULL

            -- Skip duplicate agents
            AND NOT EXISTS
            (
                SELECT 1
                FROM silver.agents s
                WHERE s.AgentID = bronze.agents.AgentID
            );

    END TRY

    BEGIN CATCH

        /*=====================================================
          Error Handling
          Capture ETL execution errors and rethrow them to the
          calling process or SQL Agent job.
        =====================================================*/

        PRINT '==============================================';
        PRINT 'ERROR OCCURRED DURING SILVER LOAD';
        PRINT '==============================================';

        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line   : ' + CAST(ERROR_LINE() AS VARCHAR(10));
        PRINT 'Procedure    : ' + ISNULL(ERROR_PROCEDURE(), 'N/A');

        THROW;

    END CATCH

END;
