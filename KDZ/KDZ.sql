--���� �����
use CommercialHospital_KDZ

------ ���� ����������� ��������� �� ���������� � ����� �� ����������

select * from PatientsToDepartments

------ ������� ������� ������� 

select * from Illness_History

select * from Patient

------ ���� ������� ������ � ��������� � ��������; 

select * from WorkersAndTheirPatients order by WorkerID asc

------ ������ ������ �� ������

select * from PriceForService 

------ ������� ������ ���������� ���������

select * from Archive



------ ������ ���� ����������
begin transaction
select * from IllnessHistory
select DateOut = getdate() from IllnessHistory where IllnessStatus=1
rollback transaction