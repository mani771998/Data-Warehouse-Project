create or alter procedure load_silver 
as
declare @starttime date, @endtime date;
Begin 
	--Cleansing of the Bronze table has been done in this
	--Inserted the cleased data to silver table successfully

	Set @starttime = cast(GETDATE() as varchar)

	Truncate table silver.crm_cust_info;

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
	Truncate table silver.crm_prd_info;

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
	----------------------------------------------------------------------------------------
	--This is for silver.crm_sales_details 
	Truncate table silver.crm_sales_details;

	insert into  silver.crm_sales_details (
		sls_ord_num ,
		sls_prd_key ,
		sls_cust_id ,
		sls_order_dt,
		sls_ship_dt ,
		sls_due_dt ,
		sls_sales ,
		sls_quantity ,
		sls_price
	)
	select 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	case
		when sls_order_dt = 0 or len(sls_order_dt) != 8 
		then Null
		else cast(cast(sls_order_dt as varchar) as date) -- coverted the date to varchar to date as this was originally from integer
		end as sls_order_dt,
	case 
		when sls_ship_dt = 0 or len(sls_ship_dt) != 8 
		then Null
		else cast(cast(sls_ship_dt as varchar) as date)
	end as  sls_ship_dt,
	case 
		when sls_due_dt  = 0 or len(sls_due_dt) != 8  
		then Null
		else cast(cast(sls_due_dt as varchar) as date)
	end as sls_due_dt,
	case
			when sls_sales is null or sls_sales <= 0 or sls_sales != sls_quantrity * abs(sls_price)
			then sls_quantrity * abs(sls_price)
			else sls_sales
	end as sls_sales,
	sls_quantrity,
	case 
			when sls_price is null or sls_price <= 0 
			then sls_sales / nullif(sls_quantrity, 0)
			else sls_price
	end sls_price
	from bronze.crm_sales_details
	----------------------------------------------------------------------------------------------------
	--Insterted into silver.erp_cust_AZ12 after cleansing
	Truncate table silver.erp_cust_AZ12;

	Insert into silver.erp_cust_AZ12
		(cid, bdate, gen)

	
	select 
	case
		when cid like 'Nas%' then substring (cid, 4, len(cid))
		else cid
	end cid,
	case
		when bdate > getdate() then null -------- We can not have the customers who are yet to be born :P
		else BDATE
	end bdate, 
	case 
		when trim(gen) in ('F', 'Female') then 'Female'
		when trim(gen) in ('M', 'Male') then 'Male'
		else 'NA'
	end as gen
	from bronze.erp_cust_AZ12
	---------------------------------------------------------------------------------------------------

	----into silver.erp_LOC_A101
	Truncate table silver.erp_LOC_A101;
	
	insert into silver.erp_LOC_A101(
	CID,
	CNTRY
	)
	SELECT 
		REPLACE(CID, '-', '') AS cid,
		CASE
			WHEN TRIM(cntry) = 'DE' THEN 'Germany' -- This has been done to remove the abbrevations 
			WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
			WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'N/A'
			ELSE TRIM(cntry)
		END AS cntry
	FROM bronze.erp_LOC_A101;
	--------------------------------------------------------------------------------------------------

	--This is the final table silver.erp_px_cat_g1v2
	Truncate table silver.erp_px_cat_g1v2;

	insert into silver.erp_px_cat_g1v2(
	id,
	cat,
	subcat,
	MAINTENANCE
	)
	select 
	id,
	cat,
	subcat,
	MAINTENANCE
	from bronze.erp_px_cat_g1v2
set @endtime = GETDATE()
 
print 'Time to load ' + cast(datediff (SECOND, @starttime, @endtime) as varchar)
END
