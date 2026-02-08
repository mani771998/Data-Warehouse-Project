/*
==================================================================

This script creates the tables in the silver schema for the CRM and ERP data. 
It first checks if the tables already exist and drops them if they do, then it creates new tables with the specified columns and data types.

==================================================================

As opposed we have now added the getdate so that we can also know when this data was loaded into the silver layer. This is useful for tracking and auditing purposes.
*/



IF object_id ('silver.crm_cust_info' , 'U') IS NOT NULL
Drop table silver.crm_cust_info;

Create table silver.crm_cust_info (
	cst_id int,
	cst_key varchar(55),
	cst_first_name varchar(255),
	cst_last_name varchar(20),
	cst_marital_status varchar(255),
	ct_gndr nvarchar(255),
	cst_created_date date,
	
);
go

IF object_id ('silver.crm_prd_info ' , 'U') IS NOT NULL
Drop table silver.crm_prd_info ;

create table silver.crm_prd_info (
	prd_id int,
	prd_key varchar(55),
	prd_nm varchar(255),
	prd_cost int,
	prd_line varchar(255),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);
go

IF object_id ('silver.crm_sales_details' , 'U') IS NOT NULL
drop table silver.crm_sales_details;

Create table silver.crm_sales_details (
	sls_ord_num int,
	sls_prd_key varchar(55),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantity int,
	sls_price int,
	dwh_create_date datetime2 default getdate()
);
Go

IF object_id ('silver.erp_cust_AZ12' , 'U') IS NOT NULL
drop table silver.erp_cust_AZ12;

Create table silver.erp_cust_AZ12 (
CID varchar(255),
BDATE date,
GEN varchar(255),
dwh_create_date datetime2 default getdate()
);
GO

IF object_id ('silver.erp_LOC_A101' , 'U') IS NOT NULL
drop table silver.erp_LOC_A101;

Create table silver.erp_LOC_A101 (
CID varchar(255),
CNTRY varchar(255),
dwh_create_date datetime2 default getdate()
);
GO

IF object_id ('silver.erp_px_cat_g1v2' , 'U') IS NOT NULL
drop table silver.erp_px_cat_g1v2; 

Create table silver.erp_px_cat_g1v2 (
ID varchar(255),
CAT varchar(255),
SUBCAT varchar(255),
MAINTENANCE varchar(255),
dwh_create_date datetime2 default getdate()
);


-----------------------------

--After quality check I had to adjust the metdata of silver.crm_prd_info

If object_id ('silver.crm_prd_info', 'U') is not null
	drop table silver.crm_prd_info;

create table silver.crm_prd_info (
	prd_id int,
	cat_id varchar(55),
	prd_key varchar(55),
	prd_nm varchar(255),
	prd_cost int,
	prd_line varchar(255),
	prd_start_dt date,
	prd_end_dt date,
	dwh_create_date datetime2 default getdate()
);


--Addtion of cat_id which was substracted from prd_key to join in future table
