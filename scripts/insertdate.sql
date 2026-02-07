/*

==================================================================

This will make sure that the data in the source files is loaded into the bronze layer of the data warehouse.
The data is loaded from the csv files into the corresponding tables in the bronze schema.
==================================================================
*/

truncate table bronze.crm_cust_info;

--Truncate is used to delete all the data from the table before loading new data. This ensures that there are no duplicate records in the table after the bulk insert operation.

Bulk Insert bronze.crm_cust_info 
from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\cust_info.csv'
with
(
	FIELDTERMINATOR = ',',
	TABLOCK,
	FIRSTROW = 2
);

go

Truncate table bronze.crm_prd_info;

bulk insert bronze.crm_prd_info
from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
with
(
FIRSTROW = 2,
Fieldterminator = ',',
Tablock
);

go

Truncate table bronze.crm_sales_details;

bulk insert bronze.crm_sales_details
from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
with
(Firstrow = 2,
fieldterminator = ',',
tablock
);

go

Truncate table bronze.erp_cust_AZ12;

bulk insert bronze.erp_cust_AZ12
from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
with 
(
firstrow = 2,
tablock,
fieldterminator = ','
);

go

Truncate table bronze.erp_LOC_A101;

bulk insert bronze.erp_LOC_A101

from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
with 
(
firstrow = 2,
tablock,
fieldterminator = ','
);

go

Truncate table bronze.erp_px_cat_g1v2;

bulk insert bronze.erp_px_cat_g1v2
from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
with 
(
	firstrow = 2,
	tablock,
	fieldterminator = ','
);


