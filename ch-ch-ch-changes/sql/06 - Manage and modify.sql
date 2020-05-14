/*
	CDC
*/
USE CDC_Demo;
GO

-- Let's look at the msdb cdc_jobs table
SELECT * FROM msdb.dbo.cdc_jobs;
GO

-- Get CDC job info
EXEC sys.sp_cdc_help_jobs;
GO

-- Tweak capture job
EXEC sys.sp_cdc_change_job
	@job_type = N'capture'
	, @maxtrans = 1000
	, @maxscans = 20
	, @continuous = 1
	, @pollinginterval = 3;
GO

EXEC sys.sp_cdc_help_jobs;
GO

-- Try adding a second capture job
EXEC sys.sp_cdc_add_job
	@job_type = N'capture'
	, @start_job = 1
	, @maxtrans = 5000
	, @maxscans = 100
	, @continuous = 1
	, @pollinginterval = 2;
GO

EXEC sys.sp_cdc_help_jobs;
GO

-- Drop cleanup job
EXEC sys.sp_cdc_drop_job
	@job_type = N'cleanup';
GO

EXEC sys.sp_cdc_help_jobs;
GO

-- We didn't really want to do that, so let's put it back!
EXEC sys.sp_cdc_add_job
	@job_type = N'cleanup'
	, @retention = 4320
	, @threshold = 5000;
GO

EXEC sys.sp_cdc_help_jobs;
GO

EXEC sys.sp_cdc_help_change_data_capture;
GO

-- Captured columns
-- The 'bad' way:
SELECT * FROM cdc.captured_columns;
GO

-- The 'good' way:
EXEC sys.sp_cdc_get_captured_columns
	@capture_instance = N'dbo_Demo_CDC';
GO

-- DDL history
-- The 'bad' way:
SELECT * FROM cdc.ddl_history;
GO

-- The 'good' way:
EXEC sys.sp_cdc_get_ddl_history
	@capture_instance = N'dbo_Demo1_CDC';
GO

-- Keep an eye on what's going on
SELECT * FROM sys.dm_cdc_log_scan_sessions;
GO

SELECT CURRENT_TIMESTAMP AS [timestamp], session_id, scan_phase, start_time, end_time, duration, latency, error_count, 
	start_lsn, current_lsn, end_lsn, tran_count, last_commit_lsn, last_commit_time, first_begin_cdc_lsn, last_commit_cdc_lsn, 
	last_commit_cdc_time, failed_sessions_count
FROM sys.dm_cdc_log_scan_sessions 
WHERE scan_phase <> 'Done';
GO

-- Find errors
SELECT COUNT(*) FROM sys.dm_cdc_errors;
GO

SELECT * FROM sys.dm_cdc_errors;
GO

/*
	Change Tracking
*/
USE CT_Demo;
GO

-- Check the size of your internal tables:
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
GO
SELECT sct1.name as CT_schema,
	sot1.name as CT_table,
	ps1.row_count as CT_rows,
	ps1.reserved_page_count*8./1024. as CT_reserved_MB,
	sct2.name as tracked_schema,
	sot2.name as tracked_name,
	ps2.row_count as tracked_rows,
	ps2.reserved_page_count*8./1024. as tracked_base_table_MB,
	CHANGE_TRACKING_MIN_VALID_VERSION(sot2.object_id) as min_valid_version
FROM sys.internal_tables AS it
JOIN sys.objects AS sot1 
	ON it.object_id=sot1.object_id
JOIN sys.schemas AS sct1 
	ON sot1.schema_id=sct1.schema_id
JOIN sys.dm_db_partition_stats AS ps1 
	ON it.object_id = ps1. object_id
		AND ps1.index_id in (0,1)
LEFT JOIN sys.objects AS sot2 
	ON it.parent_object_id=sot2.object_id
LEFT JOIN sys.schemas AS sct2 
	ON sot2.schema_id=sct2.schema_id
LEFT JOIN sys.dm_db_partition_stats ps2 
	ON sot2.object_id = ps2. object_id
		AND ps2.index_id in (0,1)
WHERE it.internal_type IN (209, 210);
GO

-- Disable auto-cleanup and make a few more changes since we have an artificially low retention period
USE master;
GO

ALTER DATABASE CT_Demo
SET CHANGE_TRACKING (CHANGE_RETENTION = 1 MINUTES, AUTO_CLEANUP = OFF);
GO

USE CT_Demo;
GO

-- Check what you have
SELECT * FROM sys.dm_tran_commit_table
ORDER BY commit_ts ASC;

-- Or more of a summary
SELECT count(*) AS number_commits,
	MIN(commit_time) AS minimum_commit_time,
	MAX(commit_time) AS maximum_commit_time
FROM sys.dm_tran_commit_table;
GO

-- Manual purging
EXEC sp_flush_commit_table_on_demand 10000;
GO

-- Check what you have
SELECT * FROM sys.dm_tran_commit_table
ORDER BY commit_ts ASC;

SELECT count(*) AS number_commits,
	MIN(commit_time) AS minimum_commit_time,
	MAX(commit_time) AS maximum_commit_time
FROM sys.dm_tran_commit_table;
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

ALTER TABLE Demo_Temporal_Default
SET TEMPORAL_HISTORY_RETENTION OFF;
GO

ALTER TABLE Demo_Temporal_Default
SET (SYSTEM_VERSIONING = ON (HISTORY_RETENTION_PERIOD = 9 MONTHS));

/*
	Triggers
*/

-- ALTER TRIGGER, or DROP/ADD