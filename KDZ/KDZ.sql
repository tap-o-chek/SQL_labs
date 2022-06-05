--чтош начнём
use CommercialHospital_KDZ

------ учёт поступления пациентов по отделениям и срока их пребывания

select * from PatientsToDepartments

------ ведение истории болезни 

select * from Illness_History

select * from Patient

------ учет лечащих врачей с привязкой к пациенту; 

select * from WorkersAndTheirPatients order by WorkerID asc

------ выдача счетов на оплату

select * from PriceForService 

------ ведение архива выписанных пациентов

select * from Archive



------ менять дату пребывания
begin transaction
select * from IllnessHistory
select DateOut = getdate() from IllnessHistory where IllnessStatus=1
rollback transaction