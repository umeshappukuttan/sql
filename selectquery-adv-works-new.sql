USE AdventureWorks2008R2
GO
SELECT Name, GroupName FROM HumanResources, Department WHERE GroupName = 'Executive General and Adminstration'

SELECT PersonPerson.FirstName, PersonPerson.LastName, SalesCredit.CreditCardID FROM Person.Person As PersonPerson INNER JOIN Sales.PersonCreditCard AS SalesCredit ON PersonPerson.BusinessEntityID = SalesCredit.BusinessEntityID