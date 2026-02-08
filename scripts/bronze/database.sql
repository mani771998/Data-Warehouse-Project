/*

==============================================================

Create Database and Schema for Datawarehouse

==============================================================
Script purpose: This script creates the Datawarehouse database and the schema for the data warehouse. 
It will check if the database already exists and if it does, it will drop the database before creating a new one.

This script set up three schemas for the data warehouse:Bronze, Silver and Gold. Each schema will have its own set of tables to store the data at different stages of the data processing.

Please not that running this script will drop the existing Datawarehouse database if it exists, so make sure to backup any important data before executing this script.
*/

Use	master;
GO

--Drop and create the Datawarehouse database

If exists (select 1 from sys.databases where name = 'Datawarehouse')
begin
alter database Datawarehouse set single_user with rollback immediate
	drop database Datawarehouse
end;
Go

--Create the Datawarehouse database

Use master;
GO

CREATE DATABASE Datawarehouse;
Go

--Create schemas for the data warehouse

Create schema Bronze;
Go

Create schema Silver;
Go

Create schema Gold;
Go

-- New database along with schemas created successfully
