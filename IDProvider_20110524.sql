USE Vault
GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usysIDProvider]') AND type in (N'U'))
DROP TABLE dbo.usysIDProvider
GO

CREATE TABLE dbo.usysIDProvider
(
	SCHEMA_TABLE VARCHAR(100) PRIMARY KEY,
	MAX_ID INT
)
GO

--IF OBJECT_ID('tempdb..#tempTable') IS NOT NULL
--	DROP TABLE #tempTable
--GO

--SELECT TABLES.TABLE_SCHEMA sc, TABLES.TABLE_NAME tb, ' = ' Equals , RowNumber = IDENTITY (INT,0,1), ',' Comma
--INTO #temptable
--From INFORMATION_SCHEMA.TABLES
--INNER JOIN INFORMATION_SCHEMA.COLUMNS ON TABLES.TABLE_NAME = COLUMNS.TABLE_NAME AND COLUMN_NAME = SUBSTRING(TABLES.TABLE_NAME, 4,99) + 'ID'
--WHERE TABLE_Type = 'Base Table'
--/*
--	SUGGESTION:

--	REPLACE NEXT 4 LINES WITH FOLLOWING LINE:

--	AND TABLES.TABLE_NAME LIKE 'tbl%'
--*/
----AND TABLES.TABLE_NAME NOT LIKE 'usys%'
----AND TABLES.TABLE_NAME NOT LIKE 'sys%'
----AND TABLES.TABLE_NAME NOT LIKE 'aspnet_%'
----AND TABLES.TABLE_NAME NOT LIKE 'stbl%'
--AND TABLES.TABLE_NAME LIKE 'tbl%'
----AND TABLES.TABLE_NAME NOT IN ('tblCountry','tblState')
--AND TABLES.TABLE_NAME >= TABLES.TABLE_NAME
--AND TABLES.TABLE_SCHEMA = 'dbo'
--group by TABLES.TABLE_CATALOG, TABLES.TABLE_SCHEMA, TABLES.TABLE_NAME
--order by TABLES.TABLE_CATALOG, TABLES.TABLE_SCHEMA, TABLES.TABLE_NAME
--GO

--UPDATE #tempTable
--SET Comma = ''
--WHERE RowNumber = (SELECT MAX(RowNumber) FROM #tempTable)

--select sc + '_' + SUBSTRING(tb, 4,99), Equals, RowNumber, Comma from #tempTable

--IF OBJECT_ID('tempdb..#tempTable2') IS NOT NULL
--	DROP TABLE #tempTable2
--GO

--select 'INSERT INTO [dbo].[usysIDProvider] SELECT ''' + sc + '_' + SUBSTRING(tb, 4,99) + ''', ISNULL(MAX(' + SUBSTRING(tb, 4, 99) + 'ID),1) from ' + sc + '.' + tb + ' GO ' RAM INTO #tempTable2
--from #tempTable
--GO

--DROP TABLE #tempTable
--GO

--IF EXISTS
--(
--		SELECT *
--		FROM INFORMATION_SCHEMA.TABLES
--		WHERE TABLE_TYPE = 'BASE TABLE'
--		AND TABLE_SCHEMA = 'dbo'
--		AND TABLE_NAME = 'usysIDProvider'
--)
--	DROP TABLE [dbo].[usysIDProvider]
--GO

--CREATE TABLE [dbo].[usysIDProvider]
--(
--	SCHEMA_TABLE VARCHAR(100) PRIMARY KEY,
--	MAX_ID INT
--)
--GO

--DECLARE @A VARCHAR(MAX)
--SET @A = ''
--SELECT @A = @A  + CAST(RAM AS VARCHAR(MAX)) FROM #tempTable2 
--EXECUTE (@A)
--GO

--DROP TABLE #tempTable2
--GO
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spIDProvider]') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.spIDProvider
GO
CREATE PROC dbo.spIDProvider
as
/*
Purpose			: Populate usysIDProvider table
Date Created	: 20110524
Author			: Kalpesh
Version			: 18.00

Ref. 			: 
Para. 			: 
DeliverableID	: 

Update History:
Date Modified	Author:	Version:	DldID		Reason


*/

DECLARE @tempTable AS TABLE(tsql1 VARCHAR(500))
DELETE FROM usysIDProvider

INSERT INTO @tempTable
SELECT 'INSERT INTO [dbo].[usysIDProvider] SELECT ''' + TABLE_SCHEMA + '_' + SUBSTRING(TABLE_NAME, 4,99) + ''', ISNULL(MAX(' + SUBSTRING(TABLE_NAME, 4, 99) + 'ID),1) from ' + TABLE_SCHEMA + '.' + TABLE_NAME + ' GO '   tsql1
FROM 
(
	SELECT tb.TABLE_SCHEMA, tb.TABLE_NAME 
	FROM INFORMATION_SCHEMA.TABLES  tb
		INNER JOIN INFORMATION_SCHEMA.COLUMNS  cl
			ON tb.TABLE_NAME = cl.TABLE_NAME 
				AND COLUMN_NAME = SUBSTRING(tb.TABLE_NAME, 4,99) + 'ID'
	WHERE tb.TABLE_SCHEMA= 'dbo' and tb.TABLE_NAME like 'tbl%'
	GROUP BY tb.TABLE_SCHEMA, tb.TABLE_NAME
) a

DECLARE @A VARCHAR(MAX)
SET @A = ''
SELECT @A = @A  + CAST(tsql1 AS VARCHAR(MAX)) FROM @tempTable
EXECUTE (@A)

UPDATE dbo.usysIDProvider
SET MAX_ID = -2147483648
WHERE MAX_ID = 0
--Select * from usysIDProvider
--exec spIDProvider
go
exec dbo.spIDProvider
go
SELECT * FROM dbo.usysIDProvider
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spGetID]') AND type in (N'P', N'PC'))
DROP PROCEDURE dbo.spGetID
GO
CREATE PROCEDURE [dbo].[spGetID]
@SCHEMA_TABLE VARCHAR(100)
,@ID_COUNT INT
AS

UPDATE dbo.usysIDProvider
SET MAX_ID = MAX_ID + @ID_COUNT
OUTPUT DELETED.MAX_ID + 1 AS START_ID, INSERTED.MAX_ID AS END_ID
WHERE SCHEMA_TABLE = @SCHEMA_TABLE
GO
GRANT EXECUTE ON dbo.spGetID to webappsuser
GO

USE [master]
GO