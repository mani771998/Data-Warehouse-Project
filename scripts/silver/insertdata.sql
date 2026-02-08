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


--This is for silver.crm_prd_info


insert into silver.crm_prd_info (
    prd_id,
	cat_id ,
	prd_key,
	prd_nm ,
	prd_cost ,
	prd_line ,
	prd_start_dt ,
	prd_end_dt
)
select prd_id,
replace(substring(prd_key, 1, 5), '-', '_') as cat_id, --Extract Category Id
SUBSTRING(prd_key, 7, len(prd_key)) as prd_key, -- Extract key
prd_nm, 
isnull(prd_cost, 0) as prd_cost, 
case trim(prd_line)
	when 'M' then 'Mountain'
	when 'R' then 'Road'
	when 'S' then 'Other Sales'
	when 'T' then 'Touring'
	else 'N/A'
end as prd_line, --  Map product line codes to descriptive value
prd_start_dt,
dateadd(day, - 1, lead(prd_start_dt) over(partition by prd_key order by prd_start_dt)) as prd_end_dt --Calculated date
from bronze.crm_prd_info


