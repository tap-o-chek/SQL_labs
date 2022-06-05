--Задача 1

select a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) as Revenue, GROUPING_ID(a.CountryRegion, a.StateProvince) as Level
from SalesLT.Address as a
inner join SalesLT.CustomerAddress as ca ON a.AddressID = ca.AddressID
inner join SalesLT.Customer as c ON ca.CustomerID = c.CustomerID
inner join SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
--group by Grouping sets (a.CountryRegion, (a.CountryRegion, a.StateProvince), ())
group by ROLLUP(a.CountryRegion,a.StateProvince)
order by a.CountryRegion, a.StateProvince


--уровни группировки дохода (Level)
select a.CountryRegion, a.StateProvince, 
		GROUPING_ID(a.CountryRegion, a.StateProvince) as Level, 
		SUM(soh.TotalDue) as Revenue
from SalesLT.Address as a
inner join SalesLT.CustomerAddress as ca ON a.AddressID = ca.AddressID
inner join SalesLT.Customer as c ON ca.CustomerID = c.CustomerID
inner join SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
group by Grouping sets (a.CountryRegion, a.StateProvince, ())
order by a.CountryRegion, a.StateProvince;


--уровнь группировки для городов
select ad.CountryRegion, ad.StateProvince,City, 
choose (GROUPING_ID(ad.CountryRegion, ad.StateProvince), 
		city +'subtotal', 
		ad.StateProvince + 'subtotal', 
		ad.CountryRegion + 'subtotal', 'Total') as Level, 
		SUM(soh.TotalDue) as Revenue
from SalesLT.Address as ad
inner join SalesLT.CustomerAddress as ca ON ad.AddressID = ca.AddressID
inner join SalesLT.Customer as c ON ca.CustomerID = c.CustomerID
inner join SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
group by Grouping sets (ad.CountryRegion, ad.StateProvince, City, ())
order by ad.CountryRegion, ad.StateProvince, City;

--Задача 2

select CompanyName, Bikes, Accessories, Clothing
from 
(select c.CompanyName as CompanyName, sum(sod.LineTotal) as Sum, v.ParentProductCategoryName as Category from SalesLT.Customer as c
join SalesLT.SalesOrderHeader as soh
	on c.CustomerID = soh.CustomerID
join SalesLT.SalesOrderDetail as sod
	on soh.SalesOrderID = sod.SalesOrderID
join SalesLT.Product as p
	on sod.ProductID = p.ProductID
join SalesLT.vGetAllCategories as v
	on p.ProductCategoryID = v.ProductCategoryID
group by v.ParentProductCategoryName, c.CompanyName) 
as sales
PIVOT (SUM(Sum) FOR Category IN([Bikes], [Accessories], [Clothing])) as pvt