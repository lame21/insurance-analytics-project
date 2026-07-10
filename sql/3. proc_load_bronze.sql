/*=====================================================================
    STORED PROCEDURE: Load Bronze Layer
    --------------------------------------------------------------------
    Purpose:
        1. Truncate all Bronze tables.
        2. Load CSV files into the Bronze tables using BULK Insert.
        3. Display progress messages.
        4. Handle errors using TRY...CATCH.
=====================================================================*/

DROP PROCEDURE IF EXISTS bronze.Load_Bronze;
GO

CREATE PROCEDURE bronze.Load_Bronze
AS
BEGIN

    SET NOCOUNT OFF;

    BEGIN TRY

        PRINT '==============================================';
        PRINT 'Starting Bronze Layer Data Load...';
        PRINT '==============================================';


        /*==============================================================
            CUSTOMERS
        ==============================================================*/

        PRINT 'Truncating bronze.customers...';
        TRUNCATE TABLE bronze.customers;

        PRINT 'Loading bronze.customers...';

        BULK INSERT bronze.customers
        FROM 'C:\Users\lamem\Downloads\Insurance\customers.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Customers loaded successfully.';
        PRINT '';


        /*==============================================================
            POLICIES
        ==============================================================*/

        PRINT 'Truncating bronze.policies...';
        TRUNCATE TABLE bronze.policies;

        PRINT 'Loading bronze.policies...';

        BULK INSERT bronze.policies
        FROM 'C:\Users\lamem\Downloads\Insurance\policies.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Policies loaded successfully.';
        PRINT '';


        /*==============================================================
            CLAIMS
        ==============================================================*/

        PRINT 'Truncating bronze.claims...';
        TRUNCATE TABLE bronze.claims;

        PRINT 'Loading bronze.claims...';

        BULK INSERT bronze.claims
        FROM 'C:\Users\lamem\Downloads\Insurance\claims.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Claims loaded successfully.';
        PRINT '';


        /*==============================================================
            PAYMENTS
        ==============================================================*/

        PRINT 'Truncating bronze.payments...';
        TRUNCATE TABLE bronze.payments;

        PRINT 'Loading bronze.payments...';

        BULK INSERT bronze.payments
        FROM 'C:\Users\lamem\Downloads\Insurance\payments.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Payments loaded successfully.';
        PRINT '';


        /*==============================================================
            AGENTS
        ==============================================================*/

        PRINT 'Truncating bronze.agents...';
        TRUNCATE TABLE bronze.agents;

        PRINT 'Loading bronze.agents...';

        BULK INSERT bronze.agents
        FROM 'C:\Users\lamem\Downloads\Insurance\agents.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Agents loaded successfully.';
        PRINT '';


        /*==============================================================
            BRANCHES
        ==============================================================*/

        PRINT 'Truncating bronze.branches...';
        TRUNCATE TABLE bronze.branches;

        PRINT 'Loading bronze.branches...';

        BULK INSERT bronze.branches
        FROM 'C:\Users\lamem\Downloads\Insurance\branches.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Branches loaded successfully.';
        PRINT '';


        /*==============================================================
            PRODUCTS
        ==============================================================*/

        PRINT 'Truncating bronze.products...';
        TRUNCATE TABLE bronze.products;

        PRINT 'Loading bronze.products...';

        BULK INSERT bronze.products
        FROM 'C:\Users\lamem\Downloads\Insurance\products.csv'
        WITH
        (
            FIRSTROW = 2,
            FIELDTERMINATOR = ',',
            ROWTERMINATOR = '0x0A'
        );

        PRINT 'Products loaded successfully.';
        PRINT '';

        PRINT '==============================================';
        PRINT 'Bronze Layer loaded successfully.';
        PRINT '==============================================';

    END TRY

    BEGIN CATCH

        PRINT '==============================================';
        PRINT 'ERROR OCCURRED DURING BRONZE LOAD';
        PRINT '==============================================';

        PRINT 'Error Number : ' + CAST(ERROR_NUMBER() AS VARCHAR(10));
        PRINT 'Error Message: ' + ERROR_MESSAGE();
        PRINT 'Error Line   : ' + CAST(ERROR_LINE() AS VARCHAR(10));
        PRINT 'Procedure    : ' + ISNULL(ERROR_PROCEDURE(), 'N/A');

        THROW;

    END CATCH

END;
GO

-- Execute the procedure
EXEC bronze.Load_Bronze;
