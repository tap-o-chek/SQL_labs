use CommercialHospital_KDZ;
-- ��������� 1: ��������� ���� ��-�� ��������
go
create or alter procedure UpdateServicePriceWithInflation @infl float = 0.05
as begin
	update CommercialHospital_KDZ.dbo.[Services]
		set Price = dbo.fn_CalcWithInfluation(Price, @infl)

	select * from [Services]
   end
go

--//������
begin tran
UpdateServicePriceWithInflation
rollback tran
select * from [Services]





-- ��������� 2:  ������ ����������� ����� ������� � ������� �������
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

--//������
begin tran
select TotalCost from IllnessHistory
PutPriceToTotal
select TotalCost from IllnessHistory
rollback tran




-- ��������� 3: ���������� ����������� ��������
-- ������� ����� ��������� / ������������ ���-�� ����
go
create procedure ThroughPut as
begin
	declare @illCount int = (select sum(Capacity) from HospitalRoom)
	declare @maxCapCount int = (select sum(MaxCapacity) from HospitalRoom)
	print('���������� ����������� �������� ' + cast(@illCount * 100 / @maxCapCount as varchar) +'%')
end
go

--//������
begin tran
ThroughPut
rollback tran





--- ��������� 4: ������� ����� ���������� ������� � ����������
go
create or alter procedure AverTimeInHospital as
begin
	declare @count int = (select COUNT(PatientID) 
					  from IllnessHistory)
	select sum(DATEDIFF(day, DateIn, DateOut))/@count as [Average time in room] 
	from IllnessHistory
end
go
--//������
begin tran
AverTimeInHospital
rollback tran