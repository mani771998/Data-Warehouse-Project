/*
==================================================================

This script creates the tables in the bronze schema for the CRM and ERP data. 
It first checks if the tables already exist and drops them if they do, then it creates new tables with the specified columns and data types.

==================================================================
*/

IF object_id ('bronze.crm_cust_info' , 'U') IS NOT NULL
Drop table bronze.crm_cust_info;

Create table bronze.crm_cust_info (
	cst_id int,
	cst_key varchar(55),
	cst_first_name varchar(255),
	cst_last_name varchar(20),
	cst_marital_status varchar(255),
	ct_gndr nvarchar(255),
	cst_created_date date,
);
go

IF object_id ('bronze.crm_prd_info ' , 'U') IS NOT NULL
Drop table bronze.crm_prd_info ;

create table bronze.crm_prd_info (
	prd_id int,
	prd_key varchar(55),
	prd_nm varchar(255),
	prd_cost int,
	prd_line varchar(255),
	prd_start_dt date,
	prd_end_dt date,
);
go

IF object_id ('bronze.crm_sales_details' , 'U') IS NOT NULL
drop table bronze.crm_sales_details;

Create table bronze.crm_sales_details (
	sls_ord_num int,
	sls_prd_key varchar(55),
	sls_cust_id int,
	sls_order_dt date,
	sls_ship_dt date,
	sls_due_dt date,
	sls_sales int,
	sls_quantrity int,
	sls_price int,
);
Go

IF object_id ('bronze.erp_cust_AZ12' , 'U') IS NOT NULL
drop table bronze.erp_cust_AZ12;

Create table bronze.erp_cust_AZ12 (
CID varchar(255),
BDATE date,
GEN varchar(255)
);
GO

IF object_id ('bronze.erp_LOC_A101' , 'U') IS NOT NULL
drop table bronze.erp_LOC_A101;

Create table bronze.erp_LOC_A101 (
CID varchar(255),
CNTRY varchar(255)
);
GO

IF object_id ('bronze.erp_px_cat_g1v2' , 'U') IS NOT NULL
drop table bronze.erp_px_cat_g1v2; 

Create table bronze.erp_px_cat_g1v2 (
ID varchar(255),
CAT varchar(255),
SUBCAT varchar(255),
MAINTENANCE varchar(255)
);


