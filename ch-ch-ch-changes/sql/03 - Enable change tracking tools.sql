/*
	CDC
*/
USE CDC_Demo;
GO

EXEC sys.sp_cdc_enable_db;
GO

SELECT name, is_cdc_enabled FROM sys.databases;
GO

EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo'
	, @source_name = N'Demo_CDC'
	, @role_name = NULL;
GO

SELECT name, is_tracked_by_cdc FROM sys.tables;
GO

-- Add a second...
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo'
	, @source_name = N'Demo_CDC'
	, @role_name = NULL
	, @capture_instance = N'dbo_Demo_CDC_1';
GO

-- And a third...
EXEC sys.sp_cdc_enable_table
	@source_schema = N'dbo'
	, @source_name = N'Demo_CDC'
	, @role_name = NULL
	, @capture_instance = N'dbo_Demo_CDC_2';
GO

/*
	Change Tracking
*/
-- Initial state:
USE master;
GO

SELECT * FROM sys.change_tracking_databases;
GO

USE CT_Demo;
GO

SELECT * FROM sys.change_tracking_tables;
GO

SELECT * FROM Demo_CT;
GO

-- Enable Change Tracking
USE master;
GO

ALTER DATABASE CT_Demo 
SET CHANGE_TRACKING = ON
(CHANGE_RETENTION = 30 DAYS, AUTO_CLEANUP = ON);
GO

USE CT_Demo;
GO

ALTER TABLE Demo_CT
ENABLE CHANGE_TRACKING
WITH (TRACK_COLUMNS_UPDATED = ON); -- We could leave this off
GO

-- Post-enable state:
-- See which DBs have change tracking enabled:
SELECT * FROM sys.change_tracking_databases

-- Or this better one courtesy of Kendra Little:
-- https://www.brentozar.com/archive/2014/06/performance-tuning-sql-server-change-tracking/
-- The whole article is great, and well worth reading.
SELECT db.name AS change_tracking_db,
	is_auto_cleanup_on,
	retention_period,
	retention_period_units_desc
FROM sys.change_tracking_databases ct
JOIN sys.databases db 
	ON ct.database_id=db.database_id;
GO

-- See which tables have change tracking enabled:
SELECT * FROM sys.change_tracking_tables

-- Or THIS one from Kendra:
-- Also from https://www.brentozar.com/archive/2014/06/performance-tuning-sql-server-change-tracking/
-- Again, you should read it.
SELECT sc.name AS tracked_schema_name,
	so.name AS tracked_table_name,
	ctt.is_track_columns_updated_on,
	ctt.begin_version /*when CT was enabled, or table was truncated */,
	ctt.min_valid_version /*syncing applications should only expect data on or after this version */ ,
	ctt.cleanup_version /*cleanup may have removed data up to this version */
FROM sys.change_tracking_tables AS ctt
JOIN sys.objects AS so 
	ON ctt.[object_id]=so.[object_id]
JOIN sys.schemas AS sc 
	ON so.schema_id=sc.schema_id;
GO

-- Let's look at what gets created:
-- The object_id of our test table:
SELECT name, object_id FROM sys.objects WHERE name = N'Demo_CT';
GO

-- Get names of parent objects and change tracking objects, plus additional metadata
SELECT so.name AS parent_name
	, SCHEMA_NAME(it.schema_id) AS object_schema
	, it.name AS internal_name
	, it.parent_object_id, it.parent_id
	, it.internal_type
	, it.internal_type_desc 
FROM sys.internal_tables AS it
JOIN sys.objects AS so
	ON so.object_id = it.parent_id
WHERE internal_type = 209;

-- And more detail on the change table
SELECT so.name as parent_name
	,SCHEMA_NAME(itab.schema_id) AS schema_name
    ,itab.name AS internal_table_name
    ,typ.name AS column_data_type 
    ,col.*
FROM sys.internal_tables AS itab
JOIN sys.columns AS col 
	ON itab.object_id = col.object_id
JOIN sys.types AS typ 
	ON typ.user_type_id = col.user_type_id
JOIN sys.objects AS so 
	ON so.object_id = itab.parent_object_id
WHERE itab.internal_type = 209
ORDER BY itab.name, col.column_id;

-- Can you query the change table directly?
USE CT_Demo;
GO

-- Remember, the naming convention is sys.change_tracking_<parent table objectid>
 SELECT * FROM sys.change_tracking_901578250 -- Update the table name before running this SELECT
-- You need a DAC connection for this - this is what the CHANGETABLE function does

/*
	Temporal
*/
-- Nothing to do here as the temporal functionality is built into the CREATE TABLE

/*
	Triggers
*/
-- INSERT
USE Trigger_Demo;
GO

CREATE TRIGGER Demo_Trigger_Insert ON Demo_Trigger FOR INSERT
AS
IF @@ROWCOUNT = 0
	BEGIN
		RETURN
	END

SET NOCOUNT ON
INSERT INTO Demo_Trigger_History
	(dmltype, dmldatetime, dmldbuser, tpsid, col1, col2, col3, col4)
SELECT 'I', GETDATE(), SUSER_SNAME(), tpsid, col1, col2, col3, col4
FROM inserted;
GO

ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Insert;
GO

-- UPDATE
CREATE TRIGGER Demo_Trigger_Update ON Demo_Trigger FOR UPDATE
AS
IF @@ROWCOUNT = 0
	BEGIN
		RETURN
	END

-- Notice we're capturing both the old value...
SET NOCOUNT ON
INSERT INTO Demo_Trigger_History
	(dmltype, dmldatetime, dmldbuser, tpsid, col1, col2, col3, col4)
SELECT 'U', GETDATE(), SUSER_SNAME(), tpsid, col1, col2, col3, col4
FROM deleted;

-- And the new...
INSERT INTO Demo_Trigger_History
	(dmltype, dmldatetime, dmldbuser, tpsid, col1, col2, col3, col4)
SELECT 'U', GETDATE(), SUSER_SNAME(), tpsid, col1, col2, col3, col4
FROM inserted;
GO

ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Update;
GO

-- DELETE
CREATE TRIGGER Demo_Trigger_Delete ON Demo_Trigger FOR INSERT
AS
IF @@ROWCOUNT = 0
	BEGIN
		RETURN
	END

SET NOCOUNT ON
INSERT INTO Demo_Trigger_History
	(dmltype, dmldatetime, dmldbuser, tpsid, col1, col2, col3, col4)
SELECT 'D', GETDATE(), SUSER_SNAME(), tpsid, col1, col2, col3, col4
FROM deleted;
GO

ALTER TABLE Demo_Trigger ENABLE TRIGGER Demo_Trigger_Delete;
GO
