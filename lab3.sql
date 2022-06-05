--Задача 1
select CompanyName, SalesOrderID, TotalDue
from SalesLT.Customer,SalesLT.SalesOrderHeader

select CompanyName, SalesOrderID, TotalDue, AddressLine1, 
	AddressLine2, City, StateProvince, PostalCode, CountryRegion
from SalesLT.Customer,SalesLT.SalesOrderHeader,
	SalesLT.Address join SalesLT.CustomerAddress on SalesLT.Address.AddressID = SalesLT.CustomerAddress.AddressID

--Задача 2
select CompanyName, FirstName, LastName,SalesOrderID, TotalDue
from SalesLT.Customer, SalesLT.SalesOrderHeader

select CustomerId, CompanyName, FirstName, LastName, coalesce(City,Phone) as Contact
from SalesLT.Customer, SalesLT.Address 

select c.CustomerID, p.ProductID
from SalesLT.Customer as c
full JOIN SalesLT.SalesOrderHeader as oh
	on c.CustomerID = oh.CustomerID
full join SalesLT.SalesOrderDetail as od
	on oh.SalesOrderID=od.SalesOrderID
full JOIN SalesLT.Product as p
	on p.ProductID = od.ProductID
