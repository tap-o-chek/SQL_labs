------- Задача 1
SELECT * FROM SalesLT.Customer

select Title, FirstName, Middlename, LastName, Suffix
from SalesLT.Customer

select SalesPerson, Title + '. ' + LastName as CustomerName, Phone
from SalesLT.Customer


----- Задача 2
select convert(varchar , CustomerID) + ' : ' + CompanyName
from SalesLT.Customer

select convert(varchar,SalesOrderID) + ' ('+ convert(varchar,RevisionNumber) +')' as OrderRevision, convert(varchar,OrderDate,102) as OrderDate
from SalesLT.SalesOrderHeader


------- Задача 3
select 
	case 
		when MiddleName is null then FirstName + ' ' + LastName
		else FirstName + ' ' + MiddleName + ' ' + LastName
	end as CustomerName
from SalesLT.Customer


UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;
select coalesce(EmailAddress,Phone) as PrimaryContact
from SalesLT.Customer


UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;
select
	case 
		when ShipDate is null then convert(varchar,SalesOrderID) + ' Awaiting Shipment'
		else convert(varchar,SalesOrderID) + ' Shipped'
	end as ShippingStatus
from SalesLT.SalesOrderHeader
