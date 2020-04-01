USE AdventureWorksLT2017;


## -- Easy Questions : As seen on SQLZoo.net

### --Show the CompanyName for James D. Kramer

SELECT CompanyName
FROM SalesLT.Customer
WHERE FirstName='James' AND MiddleName='D.' AND LastName='Kramer'


### --Show all the addresses listed for 'Modular Cycle Systems'
#### --Method 1
SELECT *
FROM SalesLT.Address
WHERE AddressID IN (
    SELECT DISTINCT AddressID
    FROM SalesLT.CustomerAddress
    WHERE CustomerID IN (
        SELECT DISTINCT CUstomerID
        FROM SalesLT.Customer
        WHERE CompanyName = 'Modular Cycle Systems'
    )
);

#### --Method 2:
SELECT a1.*
FROM SalesLT.Address AS a1
INNER JOIN SalesLT.CustomerAddress AS ca
    ON ca.AddressID = a1.AddressID
INNER JOIN SalesLT.Customer AS c
    ON ca.CustomerID = c.CustomerID
WHERE c.CompanyName = 'Modular Cycle Systems'

### --Show OrderQty, the Name and the ListPrice of the order made by CustomerID 30089
SELECT sod.OrderQty, pro.Name, pro.ListPrice
FROM SalesLT.SalesOrderDetail AS sod
JOIN SalesLT.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
JOIN SalesLT.Product as pro
    ON sod.ProductID = pro.ProductID
WHERE soh.CustomerID = 30089

### --Show the first name and the email address of customer with CompanyName 'Bike World'

SELECT FirstName, EmailAddress
FROM SalesLT.Customer
WHERE CompanyName = 'Bike World'

### --Show the CompanyName for all customers with an address in City 'Dallas'.

SELECT CompanyName
FROM SalesLT.Customer
WHERE CustomerID IN (
    SELECT CustomerID 
    FROM SalesLT.CustomerAddress
    WHERE AddressID IN (
        SELECT AddressID
        FROM SalesLT.Address
        WHERE City='Dallas'
    )
)

### --How many items with ListPrice more than $1000 have been sold?

SELECT COUNT(*) AS NUM_PROD_SOLD
FROM SalesLT.Product
WHERE ProductID IN (
    SELECT DISTINCT ProductID
    FROM SalesLT.SalesOrderDetail
)

### --Give the CompanyName of those customers with orders over $100000. Include the subtotal plus tax plus freight

SELECT c1.*, c2.TotalOrders
FROM SalesLT.Customer AS c1
INNER JOIN (
    SELECT CustomerID, SUM(SubTotal + TaxAmt) AS TotalOrders
    FROM SalesLT.SalesOrderHeader
    GROUP BY CustomerID
) AS c2
    ON c1.CustomerID = c2.CustomerID
WHERE c2.TotalOrders > 100000


### --Find the number of left racing socks ('Racing Socks, L') ordered by CompanyName 'Riding Cycles'

SELECT COUNT(*)
FROM SalesLT.Product AS prod
INNER JOIN SalesLT.SalesOrderDetail AS sod
    ON prod.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS soh
    ON sod.SalesOrderID = soh.SalesOrderID
WHERE prod.Name = 'Racing Socks, L'
AND soh.CustomerID IN (
    SELECT DISTINCT CustomerID
    FROM SalesLT.Customer
    WHERE CompanyName = 'Riding Cycles'
)