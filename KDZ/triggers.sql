use CommercialHospital_KDZ;
go
-- ������� 1
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
		throw 50002, '������: ������� ��������� ��������� ����������� ����� ��������� IllnessHistory � Patient, ���������� ��������', 0;
	end;
end
go



-- ������� 2: ������������ ���� 1.000.000
create or alter trigger TriggerPrice
on [Services]
after insert, update
as
begin
	if ((select Price from inserted) > 1000000)
		begin
			rollback tran;
			--������ ������
			throw 50003, '�������� ���� ������ ������������, ���������� ��������'', 1;
		end
end
go

--//������
select * from [Services]
insert into [Services] values (6, 'test', 20000000)
update [Services] set Price = 3000000 where ServiceID = 6
delete from [Services] where ServiceID = 6



-- ������� 3
create or alter trigger IllnessStatusChange
on IllnessHistory
after update as
begin
	print('�� �������� ������ �������')
end
go

--//������
select CardID, IllnessStatus from IllnessHistory

update IllnessHistory 
	set IllnessStatus = 1 where CardID = 2

select CardID, IllnessStatus from IllnessHistory