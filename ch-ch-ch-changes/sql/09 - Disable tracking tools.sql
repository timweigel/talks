/*
	CDC
*/
USE CDC_Demo;
GO

EXEC sys.sp_cdc_disable_table
	@source_schema = N'dbo'
	, @source_name = N'Demo_CDC'
	,  @capture_instance = N'all';
GO

SELECT name, is_tracked_by_cdc FROM sys.tables;
GO

EXEC sys.sp_cdc_disable_db;
GO

SELECT name, is_cdc_enabled FROM sys.databases;
GO

/*
	Change Tracking
*/
USE master;
GO

-- Let's disable Change Tracking!
ALTER DATABASE CT_Demo
SET CHANGE_TRACKING = OFF;
GO

-- But you can't do that - you have to go in the right order.
USE CT_Demo;
GO

ALTER TABLE Demo_CT
DISABLE CHANGE_TRACKING;
GO

USE master;
GO

ALTER DATABASE CT_Demo
SET CHANGE_TRACKING = OFF;
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

-- Just turn it off
ALTER TABLE Demo_Temporal_Default
SET (SYSTEM_VERSIONING = OFF);

-- Revert table to non-temporal
ALTER TABLE Demo_Temporal_Default
DROP PERIOD FOR SYSTEM_TIME;
GO

/*
	Triggers
*/
USE Trigger_Demo;
GO

-- Disable the trigger
ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Insert;
-- Drop the trigger
DROP TRIGGER Demo_Trigger_Insert;
GO

-- Disable the trigger
ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Update;
-- Drop the trigger
DROP TRIGGER Demo_Trigger_Update;
GO

-- Disable the trigger
ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Delete;
-- Drop the trigger
DROP TRIGGER Demo_Trigger_Delete;
GO