USE master;
GO

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
