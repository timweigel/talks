USE Temporal_Demo;
GO

-- Anonymous history table
CREATE TABLE Demo_Temporal_Anonymous(
	id			int IDENTITY(0, 1) CONSTRAINT PK_Demo_Temporal_Anonymous PRIMARY KEY CLUSTERED
	, col1		int
	, col2		int
	, col3		int
	, col4		int
	, starttime	datetime2 GENERATED ALWAYS AS ROW START NOT NULL
	, endtime	datetime2 GENERATED ALWAYS AS ROW END NOT NULL
	, PERIOD FOR SYSTEM_TIME (starttime, endtime)
)
WITH (SYSTEM_VERSIONING = ON); --<-- No retention!
GO

-- History table with the name specified
CREATE TABLE Demo_Temporal_Default(
	id			int IDENTITY(0, 1) CONSTRAINT PK_Demo_Temporal_Default PRIMARY KEY CLUSTERED
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

-- User-defined schema-compliant history table
-- Pay attention to your NULLability!
CREATE TABLE Demo_Temporal_Userdefined_History(
	id			int NOT NULL
	, col1		int
	, col2		int
	, col3		int
	, col4		int
	, starttime	datetime2 NOT NULL
	, endtime	datetime2 NOT NULL
);
GO

CREATE TABLE Demo_Temporal_Userdefined(
	id			int IDENTITY(0, 1) CONSTRAINT PK_Demo_Temporal_Userdefined PRIMARY KEY CLUSTERED
	, col1		int
	, col2		int
	, col3		int
	, col4		int
	, starttime	datetime2 GENERATED ALWAYS AS ROW START NOT NULL
	, endtime	datetime2 GENERATED ALWAYS AS ROW END NOT NULL
	, PERIOD FOR SYSTEM_TIME (starttime, endtime)
)
WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = dbo.Demo_Temporal_Userdefined_History));
GO