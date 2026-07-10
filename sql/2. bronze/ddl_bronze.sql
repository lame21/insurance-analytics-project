/*==============================================================
  BRONZE LAYER - TABLE CREATION
  ---------------------------------------------------------------
  Purpose:
  The Bronze layer stores raw data exactly as it is received from
  the source systems. No transformations or data cleansing are
  performed at this stage.

  Existing tables are dropped first to allow the script to be
  executed multiple times without errors.
==============================================================*/


/*==============================================================
  CUSTOMER TABLE
  Stores customer demographic information.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.customers;

-- Create the customers table
CREATE TABLE bronze.customers (
    CustomerID INT,
    Name VARCHAR(50),
    Gender VARCHAR(15),
    Age INT,
    City VARCHAR(50)
);


/*==============================================================
  POLICIES TABLE
  Stores insurance policy information for each customer.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.policies;

-- Create the policies table
CREATE TABLE bronze.policies (
    PolicyID INT,
    CustomerID INT,
    Product VARCHAR(50),
    Premium DECIMAL(10,2),
    StartDate VARCHAR(50)
);


/*==============================================================
  CLAIMS TABLE
  Stores insurance claims submitted against policies.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.claims;

-- Create the claims table
CREATE TABLE bronze.claims (
    ClaimID INT,
    PolicyID INT,
    ClaimAmount DECIMAL(10,2),
    Status VARCHAR(50),
    Reason VARCHAR(50)
);


/*==============================================================
  PAYMENTS TABLE
  Stores premium payment transactions.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.payments;

-- Create the payments table
CREATE TABLE bronze.payments (
    PaymentID INT,
    PolicyID INT,
    Amount DECIMAL(10,2),
    PaymentDate DATE
);


/*==============================================================
  AGENTS TABLE
  Stores information about insurance agents.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.agents;

-- Create the agents table
CREATE TABLE bronze.agents (
    AgentID INT,
    AgentName VARCHAR(50),
    BranchID INT
);


/*==============================================================
  BRANCHES TABLE
  Stores branch office information.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.branches;

-- Create the branches table
CREATE TABLE bronze.branches (
    BranchID INT,
    BranchName VARCHAR(50),
    City VARCHAR(50)
);


/*==============================================================
  PRODUCTS TABLE
  Stores the insurance products offered by the company.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS bronze.products;

-- Create the products table
CREATE TABLE bronze.products (
    ProductID INT,
    ProductName VARCHAR(50)
);
