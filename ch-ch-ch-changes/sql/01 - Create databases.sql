-- Create databases

/*------------------
- You will need to modify the path in the FILENAME to conform to your installation
------------------*/

/*
	CDC
*/
USE master;
GO

IF EXISTS(SELECT * FROM sys.databases WHERE name = N'CDC_Demo')
	BEGIN
		DROP DATABASE CDC_Demo;
	END
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = N'CDC_Demo')
	BEGIN
		CREATE DATABASE CDC_Demo
		ON PRIMARY (NAME = N'CDC_Demo'
			, FILENAME = 'C:\SQL\Data\CDC_Demo.mdf'
			, SIZE = 10
			, FILEGROWTH = 10)
		LOG ON (NAME = N'CDC_Demo_log'
			, FILENAME = 'C:\SQL\TLog\CDC_Demo_log.ldf'
			, SIZE = 10
			, FILEGROWTH = 10);
	END
GO

/*
	Change Tracking
*/
IF EXISTS(SELECT * FROM sys.databases WHERE name = N'CT_Demo')
	BEGIN
		DROP DATABASE CT_Demo;
	END
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = N'CT_Demo')
	BEGIN
		CREATE DATABASE CT_Demo
		ON PRIMARY (NAME = N'CT_Demo'
			, FILENAME = N'C:\SQL\Data\CT_Demo.mdf' 
			, SIZE = 10 
			, FILEGROWTH = 10)
		LOG ON (NAME = N'CT_Demo_log'
			, FILENAME = N'C:\SQL\Tlog\CT_Demo_log.ldf' 
			, SIZE = 10 
			, FILEGROWTH = 10)
	END
GO

/*
	Temporal
*/
IF EXISTS(SELECT * FROM sys.databases WHERE name = N'Temporal_Demo')
	BEGIN
		DROP DATABASE Temporal_Demo;
	END
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = N'Temporal_Demo')
	BEGIN
		CREATE DATABASE Temporal_Demo
		ON PRIMARY (NAME = N'Temporal_Demo'
			, FILENAME = 'C:\SQL\Data\Temporal_Demo.mdf'
			, SIZE = 10
			, FILEGROWTH = 10)
		LOG ON (NAME = N'Temporal_Demo_log'
			, FILENAME = 'C:\SQL\TLog\Temporal_Demo_log.ldf'
			, SIZE = 10
			, FILEGROWTH = 10);
	END
GO

/*
	Triggers
*/
IF EXISTS(SELECT * FROM sys.databases WHERE name = N'Trigger_Demo')
	BEGIN
		DROP DATABASE Trigger_Demo;
	END
GO

IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = N'Trigger_Demo')
	BEGIN
		CREATE DATABASE Trigger_Demo
		ON PRIMARY (NAME = N'Trigger_Demo'
			, FILENAME = N'C:\SQL\Data\Trigger_Demo.mdf' 
			, SIZE = 10 
			, FILEGROWTH = 10)
		LOG ON (NAME = N'Trigger_Demo_log'
			, FILENAME = N'C:\SQL\Tlog\Trigger_Demo_log.ldf' 
			, SIZE = 10 
			, FILEGROWTH = 10)
	END
GO