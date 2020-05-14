USE master;
GO

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
