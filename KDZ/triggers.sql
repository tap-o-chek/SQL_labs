use CommercialHospital_KDZ;
go
-- Триггер 1
create or alter trigger TriggerPatient
on IllnessHistory
after insert, update
as
begin
	if (select PatientID from inserted) 
		not in 
		(select PatientID from Patient)
	begin
		rollback;
		throw 50002, 'Ошибка: попытка нарушения ссылочной целостности между таблицами IllnessHistory и Patient, транзакция отменена', 0;
	end;
end
go



-- Триггер 2: максимальная цена 1.000.000
create or alter trigger TriggerPrice
on [Services]
after insert, update
as
begin
	if ((select Price from inserted) > 1000000)
		begin
			rollback tran;
			--выброс ошибки
			throw 50003, 'Введённая цена больше максимальной, транзакция отменена'', 1;
		end
end
go

--//пример
select * from [Services]
insert into [Services] values (6, 'test', 20000000)
update [Services] set Price = 3000000 where ServiceID = 6
delete from [Services] where ServiceID = 6



-- Триггер 3
create or alter trigger IllnessStatusChange
on IllnessHistory
after update as
begin
	print('Вы изменили статус болезни')
end
go

--//пример
select CardID, IllnessStatus from IllnessHistory

update IllnessHistory 
	set IllnessStatus = 1 where CardID = 2

select CardID, IllnessStatus from IllnessHistory