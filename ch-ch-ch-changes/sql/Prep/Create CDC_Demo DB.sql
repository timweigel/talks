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
