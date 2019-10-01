 USE AdventureWorks;

SELECT CustomerID, SalesOrderID, [SubTotal], [TotalDue]

FROM Sales.SalesOrderHeader

WHERE CustomerID = 1

--------------------------------------------------------
USE AdventureWorks;

SELECT * FROM Sales.SalesOrderHeader

WHERE [OrderDate] BETWEEN '1/1/2003' AND '1/31/2003'

-----------------------------------------------------

USE AdventureWorks2012;
SELECT * FROM [Purchasing].[PurchaseOrderHeader]
WHERE [OrderDate] BETWEEN '1/1/2008' AND '12/31/2008' AND [VendorID] 
20












 