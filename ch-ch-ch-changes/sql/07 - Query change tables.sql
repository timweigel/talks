/*
	CDC
*/
USE CDC_Demo;
GO

-- The 'bad' way to get a list of the changes:
SELECT * FROM cdc.dbo_Demo_CDC_CT;
GO

-- The 'good' way to get a list of the changes:
DECLARE 
	@from_lsn	binary(10)
	, @to_lsn	binary(10)

SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_Demo_CDC')
SET @to_lsn = sys.fn_cdc_get_max_lsn()

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Demo_CDC (@from_lsn, @to_lsn, N'all update old');
GO

-- Return only the final states:
DECLARE 
	@from_lsn	binary(10)
	, @to_lsn	binary(10)

SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_Demo_CDC')
SET @to_lsn = sys.fn_cdc_get_max_lsn()

SELECT * FROM cdc.fn_cdc_get_all_changes_dbo_Demo_CDC (@from_lsn, @to_lsn, N'all');
GO

-- Determine if a given column was updated:
DECLARE 
	@from_lsn		binary(10)
	, @to_lsn		binary(10)
	, @col2_ordinal	int;
SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_Demo_CDC');
SET @to_lsn = sys.fn_cdc_get_max_lsn();
SET @col2_ordinal = sys.fn_cdc_get_column_ordinal('dbo_Demo_CDC','col2');

SELECT sys.fn_cdc_is_bit_set(@col2_ordinal,__$update_mask) as 'col2_updated', *
FROM cdc.fn_cdc_get_all_changes_dbo_Demo_CDC( @from_lsn, @to_lsn, 'all')
WHERE __$operation = 4;
GO

/*
	Change Tracking
*/
USE CT_Demo;
GO

SELECT CHANGE_TRACKING_MIN_VALID_VERSION(OBJECT_ID('Demo_CT'));
SELECT CHANGE_TRACKING_CURRENT_VERSION();

-- Both of the CHANGETABLE varieties
SELECT * FROM CHANGETABLE(CHANGES Demo_CT, 0) AS c; -- Remember, CHANGETABLE must be aliased!

SELECT * FROM CHANGETABLE(VERSION Demo_CT, (tpsid), (13)) AS c; -- lucky 13

-- And a more useful, realistic query to check the changes:
SELECT dm.tpsid
	, dm.col1
	, dm.col2
	, dm.col3
	, dm.col4
	, c.*
FROM CHANGETABLE(CHANGES Demo_CT, 0) AS c
	LEFT OUTER JOIN Demo_CT AS dm
		ON dm.tpsid = c.tpsid
ORDER BY c.SYS_CHANGE_VERSION DESC;

-- Check to see if a column is in the mask
DECLARE @changecolumns varbinary(4100)
	, @columnid int;

SET @changecolumns = (SELECT SYS_CHANGE_COLUMNS FROM CHANGETABLE(CHANGES Demo_CT, 0) AS c WHERE tpsid = 13)
SET @columnid = (SELECT COLUMNPROPERTY((OBJECT_ID('Demo_CT')), 'col1', 'ColumnId'))

SELECT CHANGE_TRACKING_IS_COLUMN_IN_MASK(@columnid, @changecolumns);
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

SELECT * 
FROM Demo_Temporal_Default_History;
GO

DECLARE @checktime datetime2
SET @checktime = DATEADD(mi, 1, GETUTCDATE())

SELECT *
FROM Demo_Temporal_Default
FOR SYSTEM_TIME AS OF @checktime;
GO

/*
	Triggers
*/
USE Trigger_Demo;
GO

SELECT *
FROM Demo_Trigger_History