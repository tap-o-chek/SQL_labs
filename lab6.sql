--Задача 1
select ProductID, Name, ListPrice 
from SalesLT.Product
where ListPrice > 
(select AVG(UnitPrice) from SalesLT.SalesOrderDetail)

select ProductID, Name, ListPrice 
from SalesLT.Product
where (ListPrice >= 100) and ProductID in (select ProductID from SalesLT.SalesOrderDetail
where UnitPrice < 100)

select prod.ProductID, prod.Name, prod.StandardCost, prod.ListPrice, 
(select AVG(UnitPrice) from SalesLT.SalesOrderDetail 
where prod.ProductID=ProductID) as AvgSellingPrice
from SalesLT.Product as prod

select prod.ProductID, prod.Name, prod.StandardCost, prod.ListPrice, 
(select AVG(UnitPrice) from SalesLT.SalesOrderDetail 
where prod.ProductID=ProductID) as AvgSellingPrice
from SalesLT.Product as prod
where (prod.StandardCost > (select AVG(UnitPrice) from SalesLT.SalesOrderDetail))


--Задача 2
select oh.SalesOrderID, p.CustomerID, p.FirstName, p.LastName, oh.TotalDue 
from SalesLT.SalesOrderHeader as oh
CROSS APPLY dbo.ufnGetCustomerInformation(oh.CustomerID) as P

select ca.CustomerID, p.FirstName, p.LastName, ad.AddressLine1, ad.City
from  SalesLT.CustomerAddress as ca
join SalesLT.Address as ad on ca.AddressID = ad.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) as P
order by p.CustomerID

select DATEDIFF(yy,p.ModifiedDate,oh.OrderDate) as YearDifference,
		DATEDIFF(mm,p.ModifiedDate,oh.OrderDate) as MonthDifference,
		DATEDIFF(dd,p.ModifiedDate,oh.OrderDate) as DayDifference
from SalesLT.Product as p, SalesLT.SalesOrderHeader as oh