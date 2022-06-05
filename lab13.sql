----Задача 1
use AdventureWorksLT2014
--Руководство компании приняло решение о том, что товары, продаваемые в рамках одной категории,
--должны быть сопоставимы по ценам, а именно – отпускная цена товаров (ListPrice) не может
--отличаться более чем в 20 раз в рамках одной категории.


--1.1) проверить, работает ли ограничение цен
select * from SalesLT.Product as prod
--проверка, соответствует ли текущая цена ограничению, которое рассчитывается во вложенном select
where (ListPrice > (select 20 * min(ListPrice) 
					from SalesLT.Product 
					where ProductCategoryID = prod.ProductCategoryID))

if (@@rowcount > 0) -- если в строке есть нарушители, то вывести что нарушено и их кол-во
	print 'Правило 20-кратной разницы в цене нарушено у '+ @@rowcount + 'товаров'
else --нет нарушений - вывод что всё хорошо
	print 'Правило 20-кратной разницы в цене соблюдено'



--1.2) сделать триггер. который будет отменять изменения, нарушающие правило

alter trigger SalesLT.TriggerProductListPriceRules
on SalesLt.Product
after insert, update
as
begin
	if exists(select * from inserted as ins
				where (ListPrice > (select 20*min(ListPrice) 
									from SalesLT.Product 
									where ProductCategoryID = ins.ProductCategoryID)))
		begin
			rollback tran;
			--выброс ошибки
			throw 50001, 'Вносимые изменения нарушают правило 20-кратной разницы в цене товаров из одной рубрики', 1;
		end
end
go

----Задача 2

--2.1) сделать 2 триггера для поддержания ссылочной целостности между 2мя таблицами

create trigger TriggerProduct
on SalesLt.Product
after insert, update
as
begin
	if (select ProductCategoryID from inserted) 
		not in 
		(select ProductCategoryID from SalesLT.ProductCategory)
	begin
		rollback;
		throw 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами Product и ProductCategory, 
						транзакция отменена', 0;
	end;
end
go

create trigger TriggerProductCategory --делаем триггер
	on SalesLt.ProductCategory
after insert, update
as
begin
	if (select ProductCategoryID from inserted) 
		not in 
		(select ProductCategoryID from SalesLT.Product)
	begin
		rollback;
		throw 50002, 'Ошибка: попытка нарушения ссылочной целостности между 
						таблицами Product и ProductCategory, транзакция отменена', 1;
	end;
end


--2.2) тестируем триггеры

alter table SalesLT.Product nocheck constraint FK_Product_ProductCategory_ProductCategoryID;

update SalesLT.Product
set ProductCategoryID = -1
where ProductID = 680

begin tran
delete from SalesLT.ProductCategory 
		where ProductCategoryID = 5
rollback


--2.3) восстановление внешнего ключа и отключение триггеров
--выключаем проверку:
alter table SalesLT.Product nocheck constraint FK_Product_ProductCategory_ProductCategoryID;
-- отключаем триггеры:
disable trigger SalesLT.TriggerProduct on SalesLT.Product;
disable trigger SalesLT.TriggerProductCategory on SalesLT.ProductCategory;