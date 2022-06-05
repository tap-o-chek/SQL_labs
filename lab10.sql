--«адача 1
--1 добавление заголовка заказа
begin tran

declare @OrderDate datetime = Getdate()
declare @DueDate datetime = DATEADD(d, 7, Getdate())
declare @CustomerID int = 1
declare @ID int = next value for SalesLT.SalesOrderNumber

print @ID

insert into SalesLT.SalesOrderHeader (SalesOrderID, CustomerID, OrderDate, DueDate, ShipMethod) 
	values (@ID, @CustomerID, @OrderDate, @DueDate, 'CARGO TRANSPORT 5')

select * from SalesLT.SalesOrderHeader 
where SalesOrderID = @ID

rollback tran --ќткатывает транзакции до начала или до точки их сохранени€ 

--2 добавление товара к заказу

declare @SalesOrderID int = @ID
declare @ProductID int = 760
declare @OrderQty smallint = 1
declare @UnitPrice money = 782.99

if exists (select SalesOrderID from SalesLT.SalesOrderHeader where SalesOrderID=@SalesOrderID)
	begin
		insert into SalesLT.SalesOrderDetail (SalesOrderID, ProductID, OrderQty, UnitPrice) values (@SalesOrderID, @ProductID, @OrderQty, @UnitPrice)
	end
else
	begin
		print '«аказ не существует'
	end
select * from SalesLT.SalesOrderDetail 
where SalesOrderID=@SalesOrderID

rollback tran 



--«адача 2
--1 обновление цен на велосипеды 

begin tran

declare @MaxPrice money = 5000 --может заплатить
declare @AvgPrice money = 2000 -- средн€€ рыночна€

while 
	(@AvgPrice > (select AVG(ListPrice) 
					from SalesLT.Product
					where ProductCategoryID in (select ProductCategoryID
												from SalesLT.vGetAllCategories 
												where ParentProductCategoryName = 'Bikes')))
											and (@MaxPrice > (select MAX(ListPrice) 
																from SalesLT.Product 
																where ProductCategoryID 
															in (select ProductCategoryID
																from SalesLT.vGetAllCategories 
																where ParentProductCategoryName = 'Bikes')))
	begin
		update SalesLT.Product 
		set ListPrice = 1.1*ListPrice 
		where ProductCategoryID in (select ProductCategoryID
									from SalesLT.vGetAllCategories 
									where ParentProductCategoryName = 'Bikes') --обновл€ет цену
	end

declare @a money = (select MAX(ListPrice) from SalesLT.Product where ProductCategoryID in (select ProductCategoryID
					from SalesLT.vGetAllCategories where ParentProductCategoryName = 'Bikes')) --высчитывание новой средней цены на велосипед
declare @b money = (select AVG(ListPrice) from SalesLT.Product as p 
					where (select ParentProductCategoryName 
							from SalesLT.vGetAllCategories as v 
							where v.ProductCategoryID = p.ProductCategoryID) = 'Bikes') --высчитываетс€ нова€ макс цена на велик

print @a --Ќова€ средн€€ цена на велосипед
print @b --Ќова€ максимальна€ цена велосипеда

rollback tran 