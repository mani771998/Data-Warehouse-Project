--Cleasing of the Bronze table has been done in this
--Inserted the cleased data to silver table successfully

Insert into silver.crm_cust_info(
cst_id,
cst_key,
cst_first_name,
cst_last_name,
cst_marital_status,
ct_gndr,
cst_created_date
)
select 
cst_id,
cst_key,
trim(cst_first_name) as cst_firstname,
trim(cst_last_name) as cst_lastname,
 case 
	when trim(cst_marital_status) in ('M') then 'Married'
	when trim(cst_marital_status) in ('S') then 'Single'
	else 'N/A'
end as cst_marital_status,
 case 
	when trim(ct_gndr) in ('M') then 'Male'
	when trim(ct_gndr) in ('F') then 'Female'
	else 'N/A'
end ct_gndr,
cst_created_date
from (select *, 
row_number() over(partition by cst_id order by cst_created_date desc) as flag_last
from bronze.crm_cust_info
where cst_id is not null)t
where flag_last =  1


--------------------------------------------------------------------------------------
