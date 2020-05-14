USE Trigger_Demo;
GO

CREATE TABLE Demo_Trigger(
	id		int IDENTITY(0, 1),
	col1	int,
	col2	int,
	col3	int,
	col4	int
);
GO

CREATE TABLE Demo_Trigger_History (
	dmltype			char(1)
	, dmlDateTime	datetime
	, dmlDBUser		sysname
	, id			int
	, col1			int
	, col2			int
	, col3			int
	, col4			int
);
GO