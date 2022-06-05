----������ 1
use AdventureWorksLT2014
--����������� �������� ������� ������� � ���, ��� ������, ����������� � ������ ����� ���������,
--������ ���� ����������� �� �����, � ������ � ��������� ���� ������� (ListPrice) �� �����
--���������� ����� ��� � 20 ��� � ������ ����� ���������.


--1.1) ���������, �������� �� ����������� ���
select * from SalesLT.Product as prod
--��������, ������������� �� ������� ���� �����������, ������� �������������� �� ��������� select
where (ListPrice > (select 20 * min(ListPrice) 
					from SalesLT.Product 
					where ProductCategoryID = prod.ProductCategoryID))

if (@@rowcount > 0) -- ���� � ������ ���� ����������, �� ������� ��� �������� � �� ���-��
	print '������� 20-������� ������� � ���� �������� � '+ @@rowcount + '�������'
else --��� ��������� - ����� ��� �� ������
	print '������� 20-������� ������� � ���� ���������'



--1.2) ������� �������. ������� ����� �������� ���������, ���������� �������

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
			--������ ������
			throw 50001, '�������� ��������� �������� ������� 20-������� ������� � ���� ������� �� ����� �������', 1;
		end
end
go

----������ 2

--2.1) ������� 2 �������� ��� ����������� ��������� ����������� ����� 2�� ���������

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
		throw 50002, '������: ������� ��������� ��������� ����������� ����� ��������� Product � ProductCategory, 
						���������� ��������', 0;
	end;
end
go

create trigger TriggerProductCategory --������ �������
	on SalesLt.ProductCategory
after insert, update
as
begin
	if (select ProductCategoryID from inserted) 
		not in 
		(select ProductCategoryID from SalesLT.Product)
	begin
		rollback;
		throw 50002, '������: ������� ��������� ��������� ����������� ����� 
						��������� Product � ProductCategory, ���������� ��������', 1;
	end;
end


--2.2) ��������� ��������

alter table SalesLT.Product nocheck constraint FK_Product_ProductCategory_ProductCategoryID;

update SalesLT.Product
set ProductCategoryID = -1
where ProductID = 680

begin tran
delete from SalesLT.ProductCategory 
		where ProductCategoryID = 5
rollback


--2.3) �������������� �������� ����� � ���������� ���������
--��������� ��������:
alter table SalesLT.Product nocheck constraint FK_Product_ProductCategory_ProductCategoryID;
-- ��������� ��������:
disable trigger SalesLT.TriggerProduct on SalesLT.Product;
disable trigger SalesLT.TriggerProductCategory on SalesLT.ProductCategory;