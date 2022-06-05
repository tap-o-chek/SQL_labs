use CommercialHospital_KDZ;
-- Процедура 1: изменение цены из-за инфляции
go
create or alter procedure UpdateServicePriceWithInflation @infl float = 0.05
as begin
	update CommercialHospital_KDZ.dbo.[Services]
		set Price = dbo.fn_CalcWithInfluation(Price, @infl)

	select * from [Services]
   end
go

--//пример
begin tran
UpdateServicePriceWithInflation
rollback tran
select * from [Services]





-- Процедура 2:  запись вычесленной суммы лечения в историю болезни
go
create or alter procedure PutPriceToTotal
as begin
	update CommercialHospital_KDZ.dbo.IllnessHistory
		set IllnessHistory.TotalCost = IllnessHistory.TotalCost + PriceForService.Price 
		from PriceForService 
		where PriceForService.CardID = IllnessHistory.CardID
	select TotalCost from IllnessHistory
   end
go

--//пример
begin tran
select TotalCost from IllnessHistory
PutPriceToTotal
select TotalCost from IllnessHistory
rollback tran




-- Процедура 3: пропускная способность больницы
-- сколько лежит пациентов / максимальное кол-во коек
go
create procedure ThroughPut as
begin
	declare @illCount int = (select sum(Capacity) from HospitalRoom)
	declare @maxCapCount int = (select sum(MaxCapacity) from HospitalRoom)
	print('Пропускная способность больницы ' + cast(@illCount * 100 / @maxCapCount as varchar) +'%')
end
go

--//пример
begin tran
ThroughPut
rollback tran





--- Процедура 4: среднее время пребывания больных в стационаре
go
create or alter procedure AverTimeInHospital as
begin
	declare @count int = (select COUNT(PatientID) 
					  from IllnessHistory)
	select sum(DATEDIFF(day, DateIn, DateOut))/@count as [Average time in room] 
	from IllnessHistory
end
go
--//пример
begin tran
AverTimeInHospital
rollback tran