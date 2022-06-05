use CommercialHospital_KDZ;
go
CREATE SCHEMA CommercialHospital_KDZ
  authorization dbo
go

------считает цену с учЄтом инфл€ции
go
create function dbo.fn_CalcWithInfluation(@price int, @infl float)
returns float
as
begin
	return @price / (1 + @infl)
end
go


------ среднее времени пребывани€ больного в стационаре
select * from IllnessHistory
go
create or alter function dbo.fn_TimeInHospital (@PatientID int)
returns int
begin
	declare @aver int = (select DATEDIFF(day, DateIn, DateOut)
						 from IllnessHistory
						 where @PatientID = IllnessHistory.PatientID)
	return @aver
end
go

--//пример
print('—реднее врем€ пребывани€ больных в стационаре: '+ cast(dbo.fn_TimeInHospital(1) as varchar)+ ' дней')
print(dbo.fn_TimeInHospital(1))



------ наличи€ свободных мест в палатах (отдельно дл€ мужчин и дл€ женщин)
select * from HospitalRoom

print('—вободных мест дл€ женщин '+ dbo.fn_PlacesForWM(1))
print('—вободных мест дл€ мужчин '+ dbo.fn_PlacesForWM(0))

go
create function dbo.fn_PlacesForWM (@indicator int)
returns varchar
begin
	if (@indicator = 1)
	begin
		declare @women int = (select sum(MaxCapacity - Capacity)
							from HospitalRoom 
							where Gender = 'ж')
		return cast(@women as varchar)
	end
	if (@indicator = 0)
	begin
		declare @men int = (select sum(MaxCapacity - Capacity) 
							from HospitalRoom 
							where Gender = 'м')
		return cast(@men as varchar)
	end
end
go