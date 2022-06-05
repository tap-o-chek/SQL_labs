--Задача 1
select ProductID, Upper(Name) as ProductName, Round([Weight], 0) as ApproxWeight from SalesLT.Product

select ProductID, Upper(Name) as ProductName, Round([Weight], 0) as ApproxWeight, Year(SellStartDate) as SellStartYear, 
Datename(mm, SellStartDate) as SellStartMonth 
from SalesLT.Product

select ProductID, Upper(Name) as ProductName, Round([Weight], 0) as ApproxWeight, Year(SellStartDate) as SellStartYear, 
Datename(mm, SellStartDate) as SellStartMonth,
Left(ProductNumber, 2) as ProductType 
from SalesLT.Product

select ProductID, Upper(Name) as ProductName, Round([Weight], 0) as ApproxWeight, Year(SellStartDate) as SellStartYear, 
Datename(mm, SellStartDate) as SellStartMonth,
Left(ProductNumber, 2) as ProductType 
from SalesLT.Product
where Isnumeric(Size) = 1


--Задача 2
select cu.CompanyName, SOH.TotalDue as Revenue, 
RANK() OVER(ORDER BY SOH.TotalDue) as [Rank] 
from SalesLT.Customer as Cu
join SalesLT.SalesOrderHeader as SOH on cu.CustomerID = SOH.CustomerID


--Задача 3
select Pr.Name, Sum(SOD.LineTotal) as TotalRevenue from SalesLT.Product as Pr
join SalesLT.SalesOrderDetail as SOD on Pr.ProductID = SOD.ProductID 
group by Name

select Pr.Name, Sum(SOD.LineTotal) as TotalRevenue from SalesLT.Product as Pr
join SalesLT.SalesOrderDetail as SOD on Pr.ProductID = SOD.ProductID 
where SOD.LineTotal > 1000
group by Name

select Pr.Name, Sum(SOD.LineTotal) as TotalRevenue from SalesLT.Product as Pr
join SalesLT.SalesOrderDetail as SOD on Pr.ProductID = SOD.ProductID 
where SOD.LineTotal > 1000
group by Name
having Sum(SOD.LineTotal) >20000