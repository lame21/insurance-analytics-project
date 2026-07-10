/*=========================================================================
    SCRIPT: Database and Schema Creation
   ========================================================================
    Purpose:
        1. Check whether the Insurance database exists.
        2. Create the database if it does not exist.
        3. Switch to the Insurance database.
        4. Create the Bronze, Silver and Gold schemas.

   
    Notes:
        - The script can be executed multiple times safely.
        - Existing objects will not be recreated.
=========================================================================*/


/*========================================================================
    STEP 1: Create the Insurance Database
=========================================================================*/

-- Check if the database already exists
IF NOT EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = 'Insurance'
)
BEGIN

    PRINT 'Creating Insurance database...';

    CREATE DATABASE Insurance;

    PRINT 'Insurance database created successfully.';

END
ELSE
BEGIN

    PRINT 'Insurance database already exists.';

END;
GO


/*=========================================================================
    STEP 2: Switch to the Insurance Database
=========================================================================*/

USE Insurance;
GO


/*=========================================================================
    STEP 3: Create the Bronze Schema
    Purpose:
        Stores raw data exactly as received from source systems.
=========================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'bronze'
)
BEGIN

    PRINT 'Creating bronze schema...';

    EXEC('CREATE SCHEMA bronze');

    PRINT 'Bronze schema created successfully.';

END
ELSE
BEGIN

    PRINT 'Bronze schema already exists.';

END;
GO


/*=========================================================================
    STEP 4: Create the Silver Schema
    Purpose:
        Stores cleaned, validated and standardized data.
=========================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN

    PRINT 'Creating silver schema...';

    EXEC('CREATE SCHEMA silver');

    PRINT 'Silver schema created successfully.';

END
ELSE
BEGIN

    PRINT 'Silver schema already exists.';

END;
GO


/*=========================================================================
    STEP 5: Create the Gold Schema
    Purpose:
        Stores business-ready dimensional models and fact tables for
        reporting and analytics.
=========================================================================*/

IF NOT EXISTS
(
    SELECT 1
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN

    PRINT 'Creating gold schema...';

    EXEC('CREATE SCHEMA gold');

    PRINT 'Gold schema created successfully.';

END
ELSE
BEGIN

    PRINT 'Gold schema already exists.';

END;
GO


/*=========================================================================
    SCRIPT COMPLETION
=========================================================================*/

PRINT '==============================================';
PRINT 'Insurance database setup completed successfully.';
PRINT 'Database: Insurance';
PRINT 'Schemas Created: bronze, silver, gold';
PRINT '==============================================';
GO
