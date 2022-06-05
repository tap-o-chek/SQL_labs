--������ 1
select cu.CompanyName, ad.AddressLine1 , ad.City as [Address], 'Billing' as AddressType  from SalesLT.Address as ad 
join SalesLT.CustomerAddress as ca on ad.AddressID = ca.AddressID
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Main Office'


select cu.CompanyName, ad.AddressLine1 , ad.City as [Address], 'Shipping' as AddressType  from SalesLT.Address as ad 
join SalesLT.CustomerAddress as ca on ad.AddressID = ca.AddressID
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Shipping'


select cu.CompanyName, ad.AddressLine1 , ad.City as [Address], 'Billing' as AddressType  from SalesLT.Address as ad 
join SalesLT.CustomerAddress as ca on ad.AddressID = ca.AddressID
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Main Office'
union all
select cu.CompanyName, ad.AddressLine1 , ad.City as [Address], 'Shipping' as AddressType  from SalesLT.Address as ad 
join SalesLT.CustomerAddress as ca on ad.AddressID = ca.AddressID
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Shipping'
order by cu.CompanyName --���������� �� �������� ��������
--order by AddressType

--������ 2
select cu.CompanyName from SalesLT.CustomerAddress as ca
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Main Office'
except
select cu.CompanyName from  SalesLT.CustomerAddress as ca
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Shipping'


select cu.CompanyName from SalesLT.CustomerAddress as ca
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Main Office'
intersect
select cu.CompanyName from  SalesLT.CustomerAddress as ca
join SalesLT.Customer as cu on ca.CustomerID = cu.CustomerID
where ca.AddressType = 'Shipping'