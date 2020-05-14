/*
	CDC
*/
USE CDC_Demo;
GO

SELECT * FROM Demo_CDC;
GO

INSERT INTO Demo_CDC VALUES(0, 0, 0, 0);
GO

UPDATE Demo_CDC SET col2 = 999999 WHERE col4 = 0;
GO

UPDATE Demo_CDC SET col1 = 100001 WHERE col2 BETWEEN 50 AND 75;
GO

UPDATE Demo_CDC SET col4 = 777777 WHERE col4 < 10;
GO

DELETE FROM Demo_CDC WHERE tpsid % 2 = 0;
GO

SELECT * FROM Demo_CDC;
GO

/*
	Change Tracking
*/
USE CT_Demo;
GO

SELECT * FROM Demo_CT;
GO

INSERT INTO Demo_CT VALUES(0, 0, 0, 0);
GO

UPDATE Demo_CT SET col2 = 999999 WHERE col4 = 0;
GO

UPDATE Demo_CT SET col1 = 100001 WHERE col2 BETWEEN 50 AND 75;
GO

UPDATE Demo_CT SET col4 = 777777 WHERE col4 < 10;
GO

DELETE FROM Demo_CT WHERE tpsid % 2 = 0;
GO

SELECT * FROM Demo_CT;
GO

/*
	Temporal
*/
USE Temporal_Demo;
GO

SELECT * FROM Demo_Temporal_Default;
GO

INSERT INTO Demo_Temporal_Default VALUES(0, 0, 0, 0);
GO

UPDATE Demo_Temporal_Default SET col2 = 999999 WHERE col4 = 0;
GO

UPDATE Demo_Temporal_Default SET col1 = 100001 WHERE col2 BETWEEN 50 AND 75;
GO

UPDATE Demo_Temporal_Default SET col4 = 777777 WHERE col4 < 10;
GO

DELETE FROM Demo_Temporal_Default WHERE tpsid % 2 = 0;
GO

SELECT * FROM Demo_Temporal_Default;
GO

/*
	Triggers
*/
USE Trigger_Demo;
GO

SELECT * FROM Demo_Trigger;
GO

INSERT INTO Demo_Trigger VALUES(0, 0, 0, 0);
GO

UPDATE Demo_Trigger SET col2 = 999999 WHERE col4 = 0;
GO

UPDATE Demo_Trigger SET col1 = 100001 WHERE col2 BETWEEN 50 AND 75;
GO

UPDATE Demo_Trigger SET col4 = 777777 WHERE col4 < 10;
GO

DELETE FROM Demo_Trigger WHERE tpsid % 2 = 0;
GO

SELECT * FROM Demo_Trigger;
GO
