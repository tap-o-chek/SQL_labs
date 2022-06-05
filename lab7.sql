--Задача 1
select pr.ProductID, pr.Name as ProductName, descr.Name as ProductModel, descr.Summary from SalesLT.Product as pr
join SalesLT.vProductModelCatalogDescription as descr
on pr.ProductModelID = descr.ProductModelID
order by pr.ProductID


declare @Colors as table (Color varchar(15)) --объявление таблицы Colors на 15 строк
insert into @Colors
select distinct Color from SalesLT.Product
--select Color from @Colors
select ProductID, Name, Color from SalesLT.Product
where Color in (select Color from @Colors)
order by Color


create table #Sizes (Size varchar(5))  --создание таблицы Size на 5 строк

insert into #Sizes
select distinct Size 
from SalesLT.Product

SELECT SERVERPROPERTY(N'Collation')
select ProductID, Name, Size 
from SalesLT.Product
where size in (select Size from #Sizes)
order by Size desc

 
select pr.ProductID, pr.Name as ProductName, f.ParentProductCategoryName as ParentCategory, f.ProductCategoryName as Category 
from SalesLT.Product as pr
join dbo.ufnGetAllCategories() as f
on pr.ProductCategoryID = f.ProductCategoryID
order by ParentCategory, Category, ProductName


--Задача 2
select CompanyContact, sum(TotalDue) as Revenue 
from (select (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') as CompanyContact, TotalDue from SalesLT.Customer as cus
join SalesLT.SalesOrderHeader as soh on cus.CustomerID = soh.CustomerID) as cn
group by CompanyContact order by CompanyContact


with Client (CompanyContact, TotalDue) 
as (select (CompanyName + ' ('+ FirstName + ' ' + LastName + ')') as CompanyContact, soh.TotalDue from SalesLT.Customer as cus
join SalesLT.SalesOrderHeader as soh on cus.CustomerID = soh.CustomerID)
select CompanyContact, sum(TotalDue) as Revenue 
from Client
group by CompanyContact order by CompanyContact