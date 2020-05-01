USE AdventureWorksLT2017;


## -- Medium Questions : As seen on SQLZoo.net

--A "Single Item Order" is a customer order where only one item is ordered. Show the SalesOrderID and the UnitPrice for every Single Item Order.

SELECT sod1.SalesOrderID, UnitPrice
FROM SalesLT.SalesOrderDetail AS sod1
INNER JOIN (
    SELECT SalesOrderID, COUNT(*) AS ordered_items
    FROM SalesLT.SalesOrderDetail
    GROUP BY SalesOrderID
) AS sod2
    ON sod1.SalesOrderID = sod2.SalesOrderID
WHERE sod2.ordered_items = 1

--Where did the racing socks go? List the product name and the CompanyName for all Customers who ordered ProductModel 'Racing Socks'

SELECT prod.Name, cust.CompanyName
FROM SalesLT.Product AS prod
INNER JOIN SalesLT.SalesOrderDetail AS sod
	ON prod.ProductID = sod.ProductID
INNER JOIN SalesLT.SalesOrderHeader AS soh
	ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN SalesLt.Customer AS cust
	ON soh.CustomerID = cust.CustomerID
WHERE prod.Name LIKE 'Racing Socks%'

--Show the product description for culture 'fr' for product with ProductID 736.

SELECT Description
FROM SalesLT.ProductDescription AS pdesc
INNER JOIN SalesLT.ProductModelProductDescription as pmd
	ON pdesc.ProductDescriptionID = pmd.ProductDescriptionID
WHERE pmd.Culture = 'fr'
AND pmd.ProductModelID IN (
	SELECT DISTINCT ProductModelID
	FROM SalesLT.Product
	WHERE ProductID = 736
)

--Use the SubTotal value in SaleOrderHeader to list orders from the largest to the smallest. For each order show the CompanyName and the SubTotal and the total weight of the order.

SELECT
soh.SalesOrderID,
cust.CompanyName,
SUM(SubTotal) AS SubTotal,
SUM(prod.Weight) AS Weight
FROM SalesLT.Customer AS cust
INNER JOIN SalesLT.SalesOrderHeader AS soh
	ON cust.CustomerID = soh.CustomerID
INNER JOIN SalesLT.SalesOrderDetail AS sod
	ON soh.SalesOrderID = sod.SalesOrderID
INNER JOIN SalesLt.Product AS prod
	ON sod.ProductID = prod.ProductID
GROUP BY soh.SalesOrderID, cust.CompanyName
ORDER BY SubTotal

--How many products in ProductCategory 'Cranksets' have been sold to an address in 'London'?

SELECT COUNT(*) AS NumProductSold
FROM SalesLT.SalesOrderDetail AS sod
INNER JOIN SalesLT.Product AS prd
	ON sod.ProductID = prd.ProductID
INNER JOIN SalesLT.ProductCategory AS pcat
	ON prd.ProductCategoryID = pcat.ProductCategoryID
INNER JOIN SalesLT.SalesOrderHeader AS soh
	ON sod.SalesOrderID = soh.SalesOrderID
INNER JOIN SalesLT.Address AS addr
	ON soh.ShipToAddressID = addr.AddressID
WHERE pcat.Name = 'Cranksets'
AND addr.City = 'London'