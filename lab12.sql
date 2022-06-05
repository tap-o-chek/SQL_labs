----Задача 1

--1) получить все текстовые столбцы в таблице товаров

declare @Name as nvarchar(20) = 'Product'
declare @Schema as nvarchar(20) = 'SalesLT'

print @Name

select COLUMN_NAME, DATA_TYPE 
from INFORMATION_SCHEMA.COLUMNS
where (DATA_TYPE = 'nvarchar' 
		or DATA_TYPE = 'char' 
		or DATA_TYPE = 'nchar' 
		or DATA_TYPE = 'varchar' 
		or DATA_TYPE = 'nvarchar' 
		or DATA_TYPE = 'text'
		or DATA_TYPE = 'ntext') and TABLE_NAME = @Name 
								and table_schema = @Schema
 go



--2) поиск значения в текстовых столбцах таблицы и возврат соответствующих строк

declare @Name as nvarchar(20) = 'Product'
declare @Schema as nvarchar(20) = 'SalesLT'
declare @column as nvarchar(2000)
declare @Ask as nvarchar(2000)
declare @stringToFind as nvarchar(2000) = 'Bike'

declare c1 cursor local fast_forward
for
	select COLUMN_NAME 
	from INFORMATION_SCHEMA.COLUMNS
	where (DATA_TYPE = 'nvarchar' 
			or DATA_TYPE = 'char' 
			or DATA_TYPE = 'nchar' 
			or DATA_TYPE = 'varchar' 
			or DATA_TYPE = 'nvarchar' 
			or DATA_TYPE = 'text'
			or DATA_TYPE = 'ntext') and TABLE_NAME = @Name
									and table_schema = @Schema
open c1
	while (1=1)
		begin
			fetch c1 into @column
			if @@fetch_status <> 0 
				break
			set @Ask = 'select ['+ @column + '] from ['+@Schema+'].['+ @Name+ '] where ['+@column+'] like '+ '''%' + @stringToFind + '%'''
			exec (@Ask) --аналог return
		end
close c1
deallocate c1
go


----Задача	2			ммм я так вдохновлена!

--1) поместить прошлый результат в процедуру

create procedure SalesLT.uspFindStringInTable 
@schema sysname, @table sysname, @stringToFind nvarchar(2000)
as
declare @count int = 0
declare @column as nvarchar(2000)
declare @Ask as nvarchar(2000)

declare c1 cursor local fast_forward
for
	select COLUMN_NAME 
	from INFORMATION_SCHEMA.COLUMNS
	where (DATA_TYPE = 'nvarchar' 
			or DATA_TYPE ='char' 
			or DATA_TYPE ='nchar' 
			or DATA_TYPE ='varchar' 
			or DATA_TYPE ='nvarchar' 
			or DATA_TYPE ='text'
			or DATA_TYPE = 'ntext') and TABLE_NAME = @table
									and table_schema = @Schema
open c1
while (1=1)
	begin
		fetch c1 into @column
		if @@fetch_status <> 0 break
		set @Ask = 'select ['+ @column + '] from ['+@Schema+'].['+ @table+ '] where ['+@column+'] like '+ '''%' + @stringToFind + '%'''
		exec (@Ask)
		set @count = @count + @@rowcount
	end
close c1
deallocate c1

return @count
go
declare @a int
exec @a = SalesLT.uspFindStringInTable 'SalesLT', 'Product', 'Bike'
print @a

--2. Создание отчета по поиску значения в БД
go

set noCount on

declare @schema nvarchar(2000)
declare @tablename nvarchar(2000)

declare @search nvarchar(2000) = 'Bike'

declare @rowscount int
declare c2 cursor LOCAL FAST_FORWARD
for
	select distinct TABLE_SCHEMA, TABLE_NAME 
	from INFORMATION_SCHEMA.COLUMNS
open c2
	while (1=1)
		begin
			fetch c2 into @schema, @tablename
			if @@fetch_status <> 0 break
			begin try
				exec @rowscount = SalesLT.uspFindStringInTable @schema, @tablename, @search
			end try
			begin catch
				print 'Ошибка доступа';
				print error_message();
			end catch;
			if @rowscount <> 0
				print 'В таблице ' + @schema + '.' + @tablename + ' найдено строк: ' + Cast(@rowscount as nvarchar(2000))
			if @rowscount = 0
				print 'В таблице ' + @schema + '.' + @tablename + ' не найдено строк совпадений'
		end
close c2
deallocate c2

select * from dbo.BuildVersion