Open up the AdventureWorks database and retrieve either the sales order information for customer #1 (first query) or in the 2nd query one month's of data records from the SalesOrderHeader table.

The USE statement tells SSMS what database to operate on. The * means to retrieve all the columns. The FROM specifies what table to retrieve the data from. The month of data retrieved is in the WHERE statement. You can add many different filters to the WHERE statement, which is pretty important because you rarely want ALL the data rows from a table. You should see 174 rows.

For specifying filters in the where clause dates and words have to be in 'single quotes' and numbers do not. You have to know the datatype of the column that you are filtering on first, before you craft your WHERE statement. You can do that by using SSMS's Object explorer to find the database and table then right-clicking the table name and columns to see the column names and their datatypes.

The BETWEEN statement is very helpful! What to see why? You can delete the WHERE clause and run the query again to see why.

USE AdventureWorks;

SELECT [SalesOrderID]
,[CustomerID]
, [TerritoryID]
, STR([SubTotal]) AS [Sub Total], [TaxAmt]
, + '$' + CONVERT(varchar(12), [TotalDue], 1) AS [Total $ Due]

FROM Sales.SalesOrderHeader

WHERE [OrderDate] BETWEEN '1/1/2003' AND '1/31/2003'

-- a lot of SQL developers write their queries like this.
USE AdventureWorks;

SELECT T.[Name], [SalesOrderID],[CustomerID],
S.[TerritoryID],[SubTotal],[TaxAmt],[TotalDue]

FROM Sales.SalesOrderHeader AS S

INNER JOIN [Sales].[SalesTerritory] AS T
ON T.TerritoryID =S.TerritoryID

WHERE [OrderDate] BETWEEN '1/1/2003' AND '1/31/2003'
USE AdventureWorks;

SELECT T.[Name], [CustomerID], [SalesOrderID], [SubTotal],[TaxAmt],[TotalDue]

FROM Sales.SalesOrderHeader AS S

INNER JOIN [Sales].[SalesTerritory] AS T ON T.TerritoryID =S.TerritoryID

WHERE [OrderDate] BETWEEN '1/1/2003' AND '1/31/2003'

ORDER BY T.Name, CustomerID
USE AdventureWorks;

SELECT COUNT(*)

FROM Sales.SalesOrderHeader

WHERE [DueDate] BETWEEN '1/1/2003' AND '1/31/2003'
USE AdventureWorks;

SELECT DISTINCT([TerritoryID])

FROM Sales.SalesOrderHeader

ORDER BY TerritoryID
USE AdventureWorks;

SELECT t.Name, SUM(s.SubTotal) AS [Sub Total],
STR(Sum([TaxAmt])) AS [Total Taxes],
STR(Sum([TotalDue])) AS [Total Sales]

FROM Sales.SalesOrderHeader AS s

INNER JOIN Sales.SalesTerritory as t ON

s.TerritoryID = t.TerritoryID

GROUP BY t.Name
ORDER BY t.Name

----------------------------------------------------
USE Northwind;

SELECT CategoryName, COUNT(*) as ProductCount

FROM Products p

INNER JOIN Categories c ON c.CategoryID = p.CategoryID

GROUP BY CategoryName
USE AdventureWorks;

SELECT CustomerID, SUM([TotalDue]) AS Totals

FROM Sales.SalesOrderHeader

GROUP BY CustomerID
ORDER BY Totals DESC
USE AdventureWorks;

SELECT Top 10 CustomerID, STR(SUM(TaxAmt)) AS Totals

FROM Sales.SalesOrderHeader

WHERE [OrderDate] BETWEEN '1/1/2003' AND '12/31/2003'

GROUP BY CustomerID

ORDER BY Totals DESC
USE AdventureWorks;

SELECT CustomerID, SalesOrderID,
STR(SUM([SubTotal])) AS [Sub Total],
STR(SUM([TotalDue])) as [Total w Taxes & Freight]

FROM Sales.SalesOrderHeader

GROUP BY ROLLUP(CustomerID, SalesOrderID)
USE AdventureWorks;

SELECT [SalesOrderID], [SalesOrderDetailID], [ProductID], [OrderQty]
, STR([UnitPrice] * [OrderQty]) AS [Line Total]

FROM [Sales].[SalesOrderDetail]

-------------------------------------------------------------------------------
USE AdventureWorks;

SELECT [SalesOrderID], COUNT([SalesOrderDetailID]) AS [# Line Items], STR(SUM([UnitPrice] * [OrderQty])) AS [Sales Order Total]
FROM [Sales].[SalesOrderDetail]
GROUP BY SalesOrderID
------------------------------------------------------------------------------

USE AdventureWorks2012;

SELECT p.Name AS ProductName,

NonDiscountSales = (OrderQty * UnitPrice),

Discounts = ((OrderQty * UnitPrice) * UnitPriceDiscount)

FROMProduction.Product AS p

INNER JOIN Sales.SalesOrderDetail AS sod ON p.ProductID = sod.ProductID

ORDER BY ProductName DESC;
SELECT S.ProductID, p.[Name], S.SpecialOfferID, SO.[Description]

, COUNT([OrderQty]) AS [Count]

, (AVG(UnitPrice))AS [Average Price]

, STR(SUM(LineTotal)) AS SubTotal

FROM Sales.SalesOrderDetail AS S

INNER JOIN [Sales].[SpecialOffer] AS SO
ON SO.[SpecialOfferID] = S.SpecialOfferID

INNER JOIN [Production].[Product] AS p ON p.[ProductID] = S.ProductID

GROUP BY S.ProductID, p.[Name], S.SpecialOfferID, SO.[Description]

ORDER BY S.ProductID, [Count] DESC
USE AdventureWorks;

SELECT p.ProductID, [Name], AVG([UnitPrice]) AS [Average List Price]

FROM Production.Product p

INNER JOIN [Sales].[SalesOrderDetail] s

ON p.ProductID = s.[ProductID]

GROUP BY p.ProductID, [Name]

Having AVG([UnitPrice]) > 1000
ORDER BY p.ProductID
USE AdventureWorks;

SELECT sod.ProductID, AVG(sod.UnitPrice) AS [Average Price]

FROM Sales.SalesOrderDetail as sod

INNER JOIN Sales.SalesOrderHeader as soh

ON soh.SalesOrderID = sod.SalesOrderID

WHERE OrderQty > 10 AND YEAR(soh.OrderDate) = '2003'
GROUP BY ProductID
ORDER BY [Average Price] DESC
USE AdventureWorks;

SELECT ProductID, STR(SUM(LineTotal)) AS Total

FROM Sales.SalesOrderDetail

GROUP BY ProductID
HAVING SUM(LineTotal) BETWEEN 1000000 AND 2000000
ORDER BY Total
USE AdventureWorks;

SELECT PC.Name AS Category, PS.Name AS Subcategory,

DATEPART(yy, SOH.OrderDate) AS [Year]

, 'Q' + DATENAME(qq, SOH.OrderDate) AS [Qtr]
, STR(SUM(DET.UnitPrice * DET.OrderQty)) AS [$ Sales]

FROM Production.ProductSubcategory AS PS

INNER JOIN Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesOrderDetail DET ON SOH.SalesOrderID = DET.SalesOrderID

INNER JOIN Production.Product P ON DET.ProductID = P.ProductID

ON PS.ProductSubcategoryID = P.ProductSubcategoryID

INNER JOIN Production.ProductCategory PC ON PS.ProductCategoryID = PC.ProductCategoryID

WHERE YEAR(SOH.OrderDate) = '2002' or YEAR(SOH.OrderDate) ='2003'

GROUP BY DATEPART(yy, SOH.OrderDate), PC.Name, PS.Name, 'Q'

+ DATENAME(qq, SOH.OrderDate), PS.ProductSubcategoryID

ORDER BY Category, SubCategory, [Qtr]
USE AdventureWorks;

SELECT CustomerID, SalesOrderID, TaxAmt, SUM(TaxAmt)

OVER(PARTITION BY CustomerID ORDER BY CustomerID)

FROM Sales.SalesOrderHeader
USE AdventureWorks;

SELECT [Name],

SUM(CASE WHEN YEAR([OrderDate]) = 2001 THEN ([SubTotal]) END) AS [2001],
SUM(CASE WHEN YEAR([OrderDate]) = 2002 THEN ([SubTotal]) END) AS [2002],
SUM(CASE WHEN YEAR([OrderDate]) = 2003 THEN ([SubTotal]) END) AS [2003],
SUM(CASE WHEN YEAR([OrderDate]) = 2004 THEN ([SubTotal]) END) AS [2004],

SUM([SubTotal]) AS Total

FROM [Sales].[SalesOrderHeader] AS S

INNER JOIN [Sales].[SalesTerritory] AS T ON T.[TerritoryID] = S.TerritoryID

GROUP BY [Name]
ORDER BY [NAME]
SELECT s.[ProductSubcategoryID], s.[Name], p.[Name], p.[ProductNumber], p.[SafetyStockLevel], p.[ReorderPoint], inv.[Quantity], inv.Shelf, inv.Bin

FROM [Production].[Product] as p

INNER JOIN [Production].[ProductInventory] as inv
ON p.[ProductID] = inv.[ProductID]

INNER JOIN [Production].[ProductSubcategory] as s
ON s.ProductCategoryID = p.ProductSubcategoryID

WHERE inv.[Quantity] < p.[ReorderPoint] AND p.ProductSubcategoryID IS NOT NULL

ORDER BY s.[ProductSubcategoryID]
USE [AdventureWorks2012]
SELECT CONCAT([FirstName], + ' ', +[LastName]) AS Employee
, t.[TerritoryID],t.[Name] AS [Territory], s.SalesLastYear as [Emp Sales Last Year]
, [SalesQuota] AS [Emp Sales Quota], s.SalesYTD AS [Emp Sales YTD]
, [Bonus] AS [Emp Bonus], [CommissionPct] as [Emp Commission%]
, [HireDate], [MaritalStatus], t.[SalesLastYear] AS [Territory Sales Last Year]
, t.[SalesYTD] AS [Territory Sales YTD]

FROM HumanResources.Employee as e
inner join Person.Person as p on p.BusinessEntityID = e.BusinessEntityID
inner join Sales.SalesPerson as s on s.BusinessEntityID = e.BusinessEntityID
inner join [Sales].[SalesTerritory] as t on t.[TerritoryID] = s.TerritoryID
ORDER BY TerritoryID
