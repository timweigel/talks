USE master;
GO

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
