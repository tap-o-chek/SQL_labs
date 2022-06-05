--Задача 1

-- как было изначально
select Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate
from SalesLT.Product

-- 1) добавляем товар
insert into SalesLT.Product 
	(Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) 
	values ('LED Lights', 'LT-L123', 2.56, 12.99, 37, GETDATE())
select Name
from SalesLT.Product 
where ProductID = SCOPE_IDENTITY()

--посмотреть изменения
select Name
from SalesLT.Product 
where ProductCategoryID = SCOPE_IDENTITY()



-- 2) новая товарная категория с двумя товарами

insert into SalesLT.ProductCategory (Name, ParentProductCategoryID) values ('Bells and Horns', 4)

declare @id int = SCOPE_IDENTITY()

insert into SalesLT.Product (Name, ProductNumber, StandardCost, ListPrice, ProductCategoryID, SellStartDate) 
values ('Bicycle Bell', 'BB-RING', 2.47, 4.99, @id, GETDATE()),
		('Bicycle Horn', 'BB-PARP', 1.29, 3.75, @id, GETDATE())

select p.Name, p.ProductNumber, p.StandardCost, p.ListPrice, p.ProductCategoryID, p.SellStartDate, c.ProductCategoryID, c.ParentProductCategoryID 
from SalesLT.Product as p
join SalesLT.ProductCategory as c
	on c.ProductCategoryID = p.ProductCategoryID
where ParentProductCategoryID = SCOPE_IDENTITY()

 

--Задача 2

--обновление цен на товары на 10%

update SalesLT.Product
set ListPrice = 1.1*(ListPrice) -- увеличение цены на 10%
where ProductCategoryID = (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Bells and Horns')

--прекращение продаж товаров сегодня

update SalesLT.Product
set DiscontinuedDate = getdate()
where ((ProductCategoryID = 37) and (ProductNumber != 'LT-L123'))



--Задача 3

--удалить категорию товаров и товары в ней

delete from SalesLT.Product 
where ProductCategoryID = (select ProductCategoryID from SalesLT.ProductCategory where Name = 'Bells and Horns')

delete from SalesLT.ProductCategory 
where Name = 'Bells and Horns'