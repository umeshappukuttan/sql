select SalesOrderID , ProductID , LineTotal from Sales.SalesOrderDetail order by SalesOrderID
SELECT SalesOrderID,
       COUNT(ProductID) as total_products,
       SUM(LineTotal) as total_invoice
FROM SalesOrderDetail s
GROUP BY SalesOrderID
HAVING COUNT(ProductID) > 2
ORDER BY s.SalesOrderID
