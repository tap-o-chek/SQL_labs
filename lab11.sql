----Задача 1

--выбросить ошибку для несуществующих заказов

select SalesOrderID 
from SalesLT.SalesOrderDetail 

begin tran

declare @SalesOrderID int = 71782
if (exists(select SalesOrderID 
			from SalesLT.SalesOrderDetail 
			where SalesOrderID = @SalesOrderID))
	begin
		delete from SalesLT.SalesOrderDetail 
				where SalesOrderID = @SalesOrderID;
		delete from SalesLT.SalesOrderHeader 
				where SalesOrderID = @SalesOrderID;
	end
else
	begin
		declare @ToString varchar(24) = 'Заказ ' + cast(@SalesOrderID AS varchar) + ' не существует' --выброс ошибки в случае если заказ не существует
		raiserror(@ToString, 16, 0);
	end;

rollback tran --откат

--поймать выбрсываемую ошибку
begin tran

declare @SalesOrderID2 int = 71782
	begin try
		if (exists(select SalesOrderID 
					from SalesLT.SalesOrderDetail 
					where SalesOrderID = @SalesOrderID2))
			begin
				delete from SalesLT.SalesOrderDetail 
						where SalesOrderID = @SalesOrderID2;
				delete from SalesLT.SalesOrderHeader 
						where SalesOrderID = @SalesOrderID2;
		end
		else
			begin
				declare @ToString2 varchar(24) = 'Заказ ' + CAST(@SalesOrderID2 AS varchar) + ' не существует'
				RAISERROR (@ToString2, 16, 0);
			end;
	end try

begin catch
	print error_message();
	throw 50001, 'Произошла ошибка', 0;
end catch;

rollback tran --откат



----Задача 2
--сделать из двух delet-ов одну транзакцию

begin tran

declare @SalesOrderID3 int = 71782
begin try
	if (exists(select SalesOrderID 
				from SalesLT.SalesOrderDetail 
				where SalesOrderID = @SalesOrderID3))
		begin
			begin tran
				delete from SalesLT.SalesOrderDetail 
						where SalesOrderID = @SalesOrderID3;
				throw 50001, 'Произошла ошибка', 0;
				delete from SalesLT.SalesOrderHeader 
						where SalesOrderID = @SalesOrderID3;
			commit tran
		end
	else
		begin
			declare @ToString3	 varchar(24) = 'Заказ ' + cast(@SalesOrderID3 AS varchar) + ' не существует'
			raiserror (@ToString3, 16, 0);
		end;
end try

begin catch
	if @@TRANCOUNT > 0
		begin
			rollback tran
		end
	print error_message(); --вывод ошибки если транзакция не выполняется
	throw 50001, 'Произошла ошибка', 0
end catch;

rollback tran