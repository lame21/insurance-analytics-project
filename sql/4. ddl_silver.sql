
/*==============================================================================
 Description :
     This script creates the Silver layer tables for the Insurance Data
     Warehouse. The Silver layer stores cleansed, standardized, and validated
     data loaded from the Bronze layer before transformation into the Gold
     layer.

 Tables Created:
     - customers
     - policies
     - claims
     - payments
     - agents
     - branches
     - products

 Notes:
     - Existing tables are dropped before recreation.
     - This script should be executed after the Silver schema has been created.

=============================================================================*/

/*============================================================================
  CUSTOMER TABLE
  Stores customer demographic information.
==============================================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS silver.customers;

-- Create the customers table
CREATE TABLE silver.customers (
    CustomerID INT,
    Name VARCHAR(50),
    Gender VARCHAR(15),
    Age INT,
    City VARCHAR(50)
);


/*========================================================================
  POLICIES TABLE
  Stores insurance policy information for each customer.
=========================================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS silver.policies;

-- Create the policies table
CREATE TABLE silver.policies (
    PolicyID INT,
    CustomerID INT,
    Product VARCHAR(50),
    Premium DECIMAL(10,2),
    StartDate Date
);


/*==============================================================
  CLAIMS TABLE
  Stores insurance claims submitted against policies.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS silver.claims;

-- Create the claims table
CREATE TABLE silver.claims (
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
DROP TABLE IF EXISTS silver.payments;

-- Create the payments table
CREATE TABLE silver.payments (
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
DROP TABLE IF EXISTS silver.agents;

-- Create the agents table
CREATE TABLE silver.agents (
    AgentID INT,
    AgentName VARCHAR(50),
    BranchID INT
);


/*==============================================================
  BRANCHES TABLE
  Stores branch office information.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS silver.branches;

-- Create the branches table
CREATE TABLE silver.branches (
    BranchID INT,
    BranchName VARCHAR(50),
    City VARCHAR(50)
);


/*==============================================================
  PRODUCTS TABLE
  Stores the insurance products offered by the company.
==============================================================*/

-- Drop the table if it already exists
DROP TABLE IF EXISTS silver.products;

-- Create the products table
CREATE TABLE silver.products (
    ProductID INT,
    ProductName VARCHAR(50)
);


