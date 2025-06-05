-- 📌 Project Title:
-- LiquorDB – SQL Sales & Inventory Management

CREATE DATABASE LiquorDB
USE LiquorDB

-- LiquorBrands Table
CREATE TABLE LiquorBrands
(
Brand_ID INT PRIMARY KEY,
Brand_Name VARCHAR(100),
Type VARCHAR(50),
Country VARCHAR(50)
)
INSERT INTO LiquorBrands VALUES(1,'Jack Daniels','Whiskey','USA'),
(2,'Johnnie Walker','Whiskey','Scotland'),
(3,'Grey Goose','Vodka','France'),
(4,'Patron','Tequila','Mexico'),
(5,'Baileys','Liqueur','Ireland')

SELECT * FROM LiquorBrands

--LiquorSales Table (With Foreign Key)
CREATE TABLE LiquorSales
(
Sale_ID INT PRIMARY KEY,
Brand_ID INT,
Quantity_Sold INT,
Sale_Date DATE,
Store_Location VARCHAR(100),
Price_per_unit DECIMAL(10,2),
FOREIGN KEY (Brand_ID) REFERENCES LiquorBrands(Brand_ID)
)
INSERT INTO LiquorSales VALUES(101,1,10,'2025-06-01','New York',29.99),
(102,2,5,'2025-06-02','Chicago',49.99),
(103,3,20,'2025-06-03','Los Angeles', 39.99),
(104,1,7,'2025-06-04','New York',29.99),
(105,5,15,'2025-06-05','Dallas',24.50)

SELECT * FROM LiquorSales

-- Basic SQL Queries
-- Select all data from LiquorBrands / Sales data

SELECT * FROM LiquorBrands
SELECT * FROM LiquorSales

-- Select specific columns

SELECT Brand_Name, Type FROM LiquorBrands

-- Filter with WHERE clause

SELECT * FROM LiquorSales
WHERE Store_Location = 'New York'

-- Sort results with ORDER BY

SELECT * FROM LiquorSales
ORDER BY Sale_Date DESC

--  Limit the number of rows

SELECT TOP 3 *
FROM LiquorSales
ORDER BY Quantity_Sold DESC

-- Use aliases for readability

SELECT Brand_Name AS Brand, Country AS Origin FROM LiquorBrands

-- Intermediate SQL Queries

-- INNER JOIN LiquorSales with LiquorBrands

SELECT
LS.Sale_ID,
LB.Brand_Name,
LS.Quantity_Sold,
LS.Sale_Date,
LS.Store_Location
FROM LiquorSales LS
JOIN LiquorBrands LB ON LS.Brand_ID = LB.Brand_ID

-- Aggregate: Total quantity sold per brand

SELECT
Brand_ID,
SUM(Quantity_Sold) AS Total_Quantity
FROM LiquorSales
GROUP BY Brand_ID

-- JOIN with GROUP BY

SELECT
LB.Brand_Name,
SUM(LS.Quantity_Sold) AS Total_Sold
FROM LiquorSales LS
JOIN LiquorBrands LB ON LS.Brand_ID = LB.Brand_ID
GROUP BY LB.Brand_Name

-- HAVING clause (filter groups)

SELECT
LB.Brand_Name,
SUM(LS.Quantity_Sold) AS Total_Sold
FROM LiquorSales LS
JOIN LiquorBrands LB ON LS.Brand_ID = LB.Brand_ID
GROUP BY LB.Brand_Name
HAVING SUM(LS.Quantity_Sold) > 10

-- Alternative — Using a Subquery

SELECT Brand_Name, Total_Sold FROM (
    SELECT
        LB.Brand_Name,
        SUM(LS.Quantity_Sold) AS Total_Sold
    FROM LiquorSales LS
    JOIN LiquorBrands LB ON LS.Brand_ID = LB.Brand_ID
    GROUP BY LB.Brand_Name
) AS SalesSummary
WHERE Total_Sold > 10

-- Get highest-selling brand

SELECT Top 1
LB.Brand_Name,
SUM(LS.Quantity_Sold) AS Total_Sold
FROM LiquorSales LS
JOIN LiquorBrands LB ON LS.Brand_ID = LB.Brand_ID
GROUP BY LB.Brand_Name
ORDER BY SUM(LS.Quantity_Sold) DESC

-- Subquery: Brands sold in New York

SELECT Brand_Name
FROM LiquorBrands
WHERE Brand_ID IN (
SELECT Brand_ID
FROM LiquorSales
WHERE Store_Location = 'New York'
)

-- Add, Delete, and Edit Queries
--  ADD (INSERT / ALTER)

INSERT INTO LiquorBrands VALUES(6, 'Smirnoff','Vodka','Russia')

SELECT *  FROM LiquorBrands

-- Add a new liquor sale

INSERT INTO LiquorSales VALUES(106,6,12, '2025-06-06','Miami', 19.99)

SELECT * FROM LiquorSales

-- Add a new column to an existing table

ALTER TABLE LiquorSales
ADD is_promotion BIT DEFAULT 0

SELECT * FROM LiquorSales

UPDATE LiquorSales
SET is_promotion = 1
WHERE store_location = 'Miami'

-- DELETE
--  Delete a sale by ID

DELETE FROM LiquorSales
WHERE Sale_ID = 106

-- Delete all sales from a location

DELETE FROM LiquorSales
WHERE Store_Location = 'Dallas'

-- Delete a brand (after deleting its sales)

DELETE FROM LiquorSales
WHERE Brand_ID = 6

DELETE FROM LiquorBrands
WHERE Brand_ID = 6

SELECT * FROM LiquorBrands

-- EDIT (UPDATE)
-- Update price for a brand

UPDATE LiquorSales
SET Price_per_unit = 31.99
WHERE Brand_ID = 1

SELECT * FROM LiquorSales

-- Change liquor type in brand table

UPDATE LiquorBrands
SET Type = 'Blended Whiskey'
WHERE Brand_Name = 'Johnnie Walker'

SELECT * FROM LiquorBrands

-- Fix a store location typo

UPDATE LiquorSales
SET Store_Location = 'Los Angeles'
WHERE Store_Location = 'Los Angelas'

-- Add a column and mark premium sales

ALTER TABLE LiquorSales
ADD is_premium BIT DEFAULT 0

UPDATE LiquorSales
SET is_premium = 1
WHERE Price_per_unit > 400

SELECT * FROM LiquorSales
