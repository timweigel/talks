/*
	CDC
*/
USE CDC_Demo;
GO

ALTER TABLE Demo_CDC ALTER COLUMN col4 bigint;
GO

ALTER TABLE Demo_CDC ADD col5 int;
GO

UPDATE Demo_CDC SET col5 = 12345;
GO

/*
	Change Tracking
*/
USE CT_Demo;
GO

ALTER TABLE Demo_CT ALTER COLUMN col4 bigint;
GO

ALTER TABLE Demo_CT ADD col5 int;
GO

UPDATE Demo_CT SET col5 = 12345;
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

ALTER TABLE Demo_Temporal_Default ALTER COLUMN col4 bigint;
GO

ALTER TABLE Demo_Temporal_Default ADD col5 int;
GO

UPDATE Demo_Temporal_Default SET col5 = 12345;
GO

/*
	Triggers
*/
USE Trigger_Demo;
GO

ALTER TABLE Demo_Trigger ALTER COLUMN col4 bigint;
GO

ALTER TABLE Demo_Trigger ADD col5 int;
GO

UPDATE Demo_Trigger SET col5 = 12345;
GO