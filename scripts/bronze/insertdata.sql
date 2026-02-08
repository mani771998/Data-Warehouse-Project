/*
==================================================================

This will make sure that the data in the source files is loaded into the bronze layer of the data warehouse.
The data is loaded from the csv files into the corresponding tables in the bronze schema.
==================================================================
*/

-- Create stored procedure to load data into bronze tables. This will improvde efficiency and maintainability of the data loading process. The stored procedure can be scheduled to run at regular intervals to ensure that the data in the bronze layer is always up to date.

Create   procedure [dbo].[sp_load_bronze_data] as
	begin
	Declare @start_time datetime, @end_time datetime, @batch_start_time datetime, @batch_end_time datetime;
	 begin try
			Print '===================================';
			Print 'Loading data into bronze tables...';
			Print '===================================';


			Print '-------------------------';
			Print 'Loading CRM Table';
			Print '-------------------------';

			set @batch_start_time = getdate();
			print '>> Truncating table >>';
			print '>> Inserting data into table >>';
			
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
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

			print '>> Truncating table >>';
			print '>> Inserting data into table >>';
	

			Truncate table bronze.crm_prd_info;

			bulk insert bronze.crm_prd_info
			from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\prd_info.csv'
			with
			(
			FIRSTROW = 2,
			Fieldterminator = ',',
			Tablock
			);
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


			print '>> Truncating table >>';
			print '>> Inserting data into table >>';
	

			Truncate table bronze.crm_sales_details;

			bulk insert bronze.crm_sales_details
			from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_crm\sales_details.csv'
			with
			(Firstrow = 2,
			fieldterminator = ',',
			tablock
			);
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';


			Print '-------------------------';
			Print 'Loading ERP Table';
			Print '-------------------------';


			print '>> Truncating table >>';
			print '>> Inserting data into table >>';
	


			Truncate table bronze.erp_cust_AZ12;

			bulk insert bronze.erp_cust_AZ12
			from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\CUST_AZ12.csv'
			with 
			(
			firstrow = 2,
			tablock,
			fieldterminator = ','
			);
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';



			print '>> Truncating table >>';
			print '>> Inserting data into table >>';
	


			Truncate table bronze.erp_LOC_A101;

			bulk insert bronze.erp_LOC_A101

			from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\LOC_A101.csv'
			with 
			(
			firstrow = 2,
			tablock,
			fieldterminator = ','
			);
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';

			print '>> Truncating table >>';
			print '>> Inserting data into table >>';

			Truncate table bronze.erp_px_cat_g1v2;

			bulk insert bronze.erp_px_cat_g1v2
			from 'C:\Users\biker\OneDrive\Desktop\sql-data-warehouse-project-main\sql-data-warehouse-project-main\datasets\source_erp\PX_CAT_G1V2.csv'
			with 
			(
				firstrow = 2,
				tablock,
				fieldterminator = ','
			);	
			Set @start_time = getdate();
			Set @end_time = getdate();
			print 'Time to load:' + cast(datediff(second, @start_time, @end_time) as nvarchar) + ' seconds';
		end try
	begin catch
	print 'Error Occured Please check';
end catch        

set @batch_end_time = getdate();
				 
	 Print 'Time to load Bronze Layer: ' + cast (datediff(second, @batch_start_time, @batch_end_time) as varchar) + ' seconds';

end



GO


