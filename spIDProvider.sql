--A Simple Example of Contained Databases
Use vault
go
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

UPDATE usysIDProvider
SET MAX_ID = -2147483648
WHERE MAX_ID = 0
--Select * from usysIDProvider
--exec spIDProvider
go