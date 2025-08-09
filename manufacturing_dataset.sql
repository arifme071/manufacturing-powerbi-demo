-- ============================================
-- Database & Tables Setup
-- ============================================
IF DB_ID('Power_BI2') IS NULL
    CREATE DATABASE Power_BI2;
GO

USE Power_BI2;
GO

-- Drop in dependency order
IF OBJECT_ID('ProductionTransactions', 'U') IS NOT NULL DROP TABLE ProductionTransactions;
IF OBJECT_ID('ProductionTeams', 'U') IS NOT NULL DROP TABLE ProductionTeams;
IF OBJECT_ID('Products', 'U') IS NOT NULL DROP TABLE Products;

-- Products Table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName NVARCHAR(100),
    Size NVARCHAR(50)
);

-- Teams Table
CREATE TABLE ProductionTeams (
    TeamID INT PRIMARY KEY,
    ShiftCode VARCHAR(1),
    TeamName NVARCHAR(50)
);

-- Transactions Table
CREATE TABLE ProductionTransactions (
    ProductID INT,
    TeamID INT,
    ProductionDate VARCHAR(20),
    QuantityProduced INT,
    QuantityDefective INT,
    DowntimeMinutes FLOAT,
    OvertimeHours FLOAT,
    RegularHours FLOAT,
    RawMaterialCost FLOAT,
    LaborCost FLOAT,
    OverheadCost FLOAT,
    TotalProductionCost FLOAT,
    MaterialUsedKg VARCHAR(20),
    MaterialExpectedKg FLOAT,
    OperatorName NVARCHAR(100),
    SupplyQty INT,
    DemandQty INT,
    SaleUnits INT,
    GeoLocation VARCHAR(50)
);

-- ============================================
-- Base Data
-- ============================================
INSERT INTO Products VALUES
(1, 'Widget X', 'Small'),
(2, 'Widget X', 'Medium'),
(3, 'Widget X', 'Large');

INSERT INTO ProductionTeams VALUES
(1, 'A', 'Team A Shift A'),
(2, 'B', 'Team B Shift B'),
(3, 'C', 'Team C Shift C');

-- ============================================
-- Generate Synthetic Transactions
-- ============================================
;WITH Numbers AS (
    SELECT TOP (10000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS rn
    FROM sys.all_objects a CROSS JOIN sys.all_columns b
)
INSERT INTO ProductionTransactions
SELECT
    (rn % 3) + 1 AS ProductID,
    (rn % 3) + 1 AS TeamID,
    CASE 
        WHEN rn % 4 = 0 THEN CONVERT(VARCHAR(10), DATEADD(DAY, rn%365, '2024-01-01'), 23)
        WHEN rn % 4 = 1 THEN FORMAT(DATEADD(DAY, rn%365, '2024-01-01'), 'dd/MM/yyyy')
        ELSE CONVERT(VARCHAR(10), DATEADD(DAY, rn%365, '2024-01-01'), 101)
    END,
    CASE WHEN rn % 200 = 0 THEN NULL WHEN rn % 500 = 0 THEN 99999 ELSE 100 + (rn % 50) END,
    CASE WHEN rn % 300 = 0 THEN NULL WHEN rn % 700 = 0 THEN 500 ELSE rn % 10 END,
    CASE WHEN rn % 150 = 0 THEN NULL WHEN rn % 600 = 0 THEN 400 ELSE rn % 45 END,
    CAST((rn % 5) + (RAND(CHECKSUM(NEWID())) * 2) AS DECIMAL(4,2)),
    CASE WHEN rn % 50 = 0 THEN 7 ELSE 8 END,
    30 + (rn % 20),
    20 + (rn % 15),
    10 + (rn % 8),
    (30 + (rn % 20)) + (20 + (rn % 15)) + (10 + (rn % 8)),
    CASE WHEN rn % 5 = 0 THEN FORMAT(2.2 + RAND(CHECKSUM(NEWID())), 'N2') + 'kg'
         WHEN rn % 6 = 0 THEN CONVERT(VARCHAR(10), CAST(2000 + RAND(CHECKSUM(NEWID())) * 400 AS INT)) + 'g'
         ELSE FORMAT(2.1 + RAND(CHECKSUM(NEWID())), 'N2')
    END,
    2.1,
    CASE WHEN rn % 4 = 0 THEN 'Alice Johnson'
         WHEN rn % 4 = 1 THEN 'alice johnson'
         ELSE ' Alice Johnson ' END,
    120 + (rn % 30),
    100 + (rn % 30),
    80 + (rn % 50),
    CASE WHEN rn % 10 = 0 THEN 'New York'
         WHEN rn % 10 = 1 THEN 'Delhi'
         WHEN rn % 10 = 2 THEN 'London'
         WHEN rn % 10 = 3 THEN 'Tokyo'
         WHEN rn % 10 = 4 THEN 'Sydney'
         WHEN rn % 10 = 5 THEN 'São Paulo'
         WHEN rn % 10 = 6 THEN 'Berlin'
         WHEN rn % 10 = 7 THEN 'Shanghai'
         ELSE 'Paris' END
FROM Numbers;

-- ============================================
-- Date Standardization
-- ============================================
UPDATE ProductionTransactions
SET ProductionDate = 
    CASE
        WHEN TRY_CONVERT(date, ProductionDate, 101) IS NOT NULL 
            THEN FORMAT(TRY_CONVERT(date, ProductionDate, 101), 'MM/dd/yyyy')
        WHEN TRY_CONVERT(date, ProductionDate, 23) IS NOT NULL    
            THEN FORMAT(TRY_CONVERT(date, ProductionDate, 23), 'MM/dd/yyyy')
        WHEN TRY_CONVERT(date, ProductionDate, 103) IS NOT NULL
            THEN FORMAT(TRY_CONVERT(date, ProductionDate, 103), 'MM/dd/yyyy')
        ELSE ProductionDate
    END;

-- ============================================
-- Create Combined Dataset
-- ============================================
IF OBJECT_ID('CombinedManufacturingDataset', 'U') IS NOT NULL DROP TABLE CombinedManufacturingDataset;

SELECT
    t.ProductID,
    t.ProductionDate,
    p.ProductName,
    p.Size,
    team.ShiftCode,
    team.TeamName,
    t.QuantityProduced,
    t.QuantityDefective,
    t.DowntimeMinutes,
    t.OvertimeHours,
    t.RegularHours,
    t.RawMaterialCost,
    t.LaborCost,
    t.OverheadCost,
    t.TotalProductionCost,
    t.MaterialUsedKg,
    t.MaterialExpectedKg,
    t.OperatorName,
    t.SupplyQty,
    t.DemandQty,
    t.SaleUnits,
    t.GeoLocation
INTO CombinedManufacturingDataset
FROM ProductionTransactions t
LEFT JOIN Products p ON t.ProductID = p.ProductID
LEFT JOIN ProductionTeams team ON t.TeamID = team.TeamID;

SELECT TOP 50 * FROM CombinedManufacturingDataset;
