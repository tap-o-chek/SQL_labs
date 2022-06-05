--Задача 1
select distinct City, StateProvince 
from SalesLT.Address

select top 10 percent weight 
from SalesLT.Product order by weight desc

select Weight 
from SalesLT.Product order by weight desc offset(10) rows fetch next (100) rows only

-- Задача 2
select Name,Color,Size
from SalesLT.Product
where ProductNumber = '1'

select ProductNumber, Name
from SalesLT.Product
where Color in('black', 'red', 'white') and Size in ('S', 'M')

select ProductNumber, Name, ListPrice
from SalesLT.Product
where ProductNumber like 'BK-%'

select ProductNumber, Name, ListPrice
from SalesLT.Product
where ProductNumber like 'BK-%[^r]%-[0-9][0-9]'