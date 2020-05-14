/*
	CDC
*/

USE CDC_Demo;
GO

CREATE TABLE Demo_CDC(
	tpsid		int IDENTITY(0, 1) CONSTRAINT PK_Demo_CDC PRIMARY KEY CLUSTERED
	, col1	int
	, col2	int
	, col3	int
	, col4	int
);
GO

/*
	Change tracking
*/
USE CT_Demo;
GO

CREATE TABLE Demo_CT(
	tpsid		int IDENTITY(0, 1) CONSTRAINT PK_Demo_CT PRIMARY KEY CLUSTERED
	, col1	int
	, col2	int
	, col3	int
	, col4	int
);
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

-- History table with the name specified
CREATE TABLE Demo_Temporal_Default(
	tpsid			int IDENTITY(0, 1) CONSTRAINT PK_Demo_Temporal_Default PRIMARY KEY CLUSTERED
	, col1		int
	, col2		int
	, col3		int
	, col4		int
	, starttime	datetime2 GENERATED ALWAYS AS ROW START NOT NULL
	, endtime	datetime2 GENERATED ALWAYS AS ROW END NOT NULL
	, PERIOD FOR SYSTEM_TIME (starttime, endtime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Demo_Temporal_Default_History
								, HISTORY_RETENTION_PERIOD = 30 DAYS)); --<-- Retention is available in 2017
GO

/*
	Triggers
*/
USE Trigger_Demo;
GO

CREATE TABLE Demo_Trigger(
	tpsid		int IDENTITY(0, 1) CONSTRAINT PK_Demo_Trigger PRIMARY KEY CLUSTERED
	, col1	int
	, col2	int
	, col3	int
	, col4	int
);
GO

CREATE TABLE Demo_Trigger_History (
	dmltype			char(1)
	, dmlDateTime	datetime
	, dmlDBUser		sysname
	, tpsid			int
	, col1			int
	, col2			int
	, col3			int
	, col4			int
);
GO