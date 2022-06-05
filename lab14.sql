-- Задача 1
use AdventureWorksLT2014
--1.1) получить всю сумму потраченную клиентом

set ansi_nulls on
go
set quoted_identifier on
go

create function dbo.fn_GetOrdersTotalDueForCustomer(@CustomerID int)---- функция
returns float
as
begin
	declare @total_due float;
	select @total_due = sum(TotalDue) 
	from SalesLT.SalesOrderHeader
	where CustomerID = @CustomerID;
	return @total_due
end
go

print dbo.fn_GetOrdersTotalDueForCustomer(711)


--1.2) достать все типы адресов у клиентов

select * from SalesLT.Address;
select * from SalesLT.CustomerAddress;

set ansi_nulls on
go
set quoted_identifier on
go

create view vallAddresses
as select CA.CustomerID, CA.AddressType, CA.AddressID, A.AddressLine1, A.AddressLine2, A.City, 
			A.StateProvince, A.CountryRegion, A.PostalCode
	from SalesLT.CustomerAddress as CA 
	join SalesLT.Address as A
		on A.AddressID = CA.AddressID
go


--1.3) достать все адреса клиентааа

select * from vallAddresses;
select * from SalesLT.Address;

set ansi_nulls on
go
set quoted_identifier on
go

create function dbo.fn_GetAddressesForCustomer(@CustomerID int)---- функция
returns table
as
return (select AddressLine1, AddressLine2 
		from vallAddresses
		where CustomerID = @CustomerID)
go

select * from dbo.fn_GetAddressesForCustomer(30018);

--1.4) макс и мин суммы продаж

select * from SalesLT.SalesOrderDetail;

set ansi_nulls on
go
set quoted_identifier on
go

create function dbo.fn_GetMinMaxOrderPricesForProduct(@ProductID int)---- функция
returns table
as
return (select max(UnitPrice) as MaxUnitPrice, 
				min(UnitPrice) as MinUnitPrice 
		from SalesLT.SalesOrderDetail
		where ProductID = @ProductID)
go

--select * from dbo.fn_GetMinMaxOrderPricesForProduct(0);
select * from dbo.fn_GetMinMaxOrderPricesForProduct(711);


--1.5) получить описания товара

select * from SalesLT.vProductAndDescription;

set ansi_nulls on
go
set quoted_identifier on
go

create function dbo.fn_GetallDescriptionsForProduct(@ProductID int)---- функция
returns table
as
return (select pr.ProductID, pr.Name, f.MaxUnitPrice, f.MinUnitPrice, prod.ListPrice, pr.ProductModel, 
				pr.Culture, pr.Description
		from SalesLT.vProductAndDescription as pr
				join SalesLT.Product as prod
					on pr.ProductID = prod.ProductID
				join dbo.fn_GetMinMaxOrderPricesForProduct(@ProductID) as f
					on prod.ProductID = @ProductID)
go

select * from dbo.fn_GetallDescriptionsForProduct(711);




--- Задача 2

-- 2.1) материализация прости хосподи

SET ARITHABORT ON
SET CONCAT_NULL_YIELDS_NULL ON
SET QUOTED_IDENTIFIER ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
SET NUMERIC_ROUNDABORT OFF
GO

alter view dbo.vAllAddresses with Schemabinding
as select ag.CustomerID, ag.AddressType, p.AddressID
from SalesLT.Address, SalesLT.Product as p join SalesLT.CustomerAddress as ag 
on 
-- создадим кластерный индекс на VIEW, тем самым сделав его материализованным
CREATE UNIQUE CLUSTERED INDEX [UIX_vAllAddresses] ON [SalesLT].[vAllAddresses]
(
	[ParentProductCategoryName] ASC,
	[ProductCategoryName] ASC,
	[Name] ASC, -- Product.Name
	[ProductID] ASC -- Product.Name
) ON [PRIMARY]
GO

SELECT * FROM [dbo].[vAllAddresses] WITH (NOEXPAND)