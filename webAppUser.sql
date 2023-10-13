alter PROC [dbo].[spRestoreGrants]
AS
/*
Purpose				:	Restore permission to database objects (Stored procedures, tables and fucntions) for WebAppsUser user
SRS Document		:	
Paragrahp			:	
Date Created		:	20091130
Author				:	Kalpesh
Tested by			:	Kalpesh
Version				:   120.90  	?  --  SELECT max(VersionID) FROM usysVersion

PARAMETER NOTES:

Update History:
Date Modified	Author:	Version:	Reason

*/
BEGIN

DECLARE @tSQL AS NVARCHAR(1000)

--TABLES
DECLARE curGrant CURSOR
FOR
	SELECT 'GRANT SELECT ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.tables a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id
	UNION ALL
	SELECT 'GRANT INSERT ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.tables a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id	
	UNION ALL
	SELECT 'GRANT UPDATE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.tables a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id						
	UNION ALL
	SELECT 'GRANT DELETE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.tables a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id	
	OPEN curGrant
	
	FETCH NEXT FROM curGrant INTO @tSQL
	WHILE @@fetch_status = 0
		BEGIN
			--PRINT @tSQL
			EXEC SP_EXECUTESQL @tSQL
			FETCH NEXT FROM curGrant INTO @tSQL			
		END
CLOSE curGrant
DEALLOCATE curGrant

--TABLES
DECLARE curGrant CURSOR
FOR

	SELECT 'GRANT SELECT ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.views a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id	
	UNION ALL
	SELECT 'GRANT INSERT ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.views a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id	
	UNION ALL
	SELECT 'GRANT UPDATE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.views a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id
	UNION ALL
	SELECT 'GRANT DELETE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.views a
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id
	OPEN curGrant
	
	FETCH NEXT FROM curGrant INTO @tSQL
	WHILE @@fetch_status = 0
		BEGIN
			--PRINT @tSQL
			EXEC SP_EXECUTESQL @tSQL
			FETCH NEXT FROM curGrant INTO @tSQL			
		END
CLOSE curGrant
DEALLOCATE curGrant

--STORED PROCEDURES
DECLARE curGrant CURSOR
FOR
	SELECT 'GRANT EXECUTE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.procedures a  
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id
	ORDER BY b.Name, a.Name
	OPEN curGrant

	FETCH NEXT FROM curGrant INTO @tSQL
	WHILE @@fetch_status = 0
		BEGIN
			--PRINT @tSQL
			EXEC SP_EXECUTESQL @tSQL
			FETCH NEXT FROM curGrant INTO @tSQL			
		END
CLOSE curGrant
DEALLOCATE curGrant

--FUCNTIONS
DECLARE curGrant CURSOR
FOR
	SELECT 'GRANT EXECUTE ON [' + b.Name +'].[' +  a.Name +'] TO WebAppsUser'
	FROM sys.objects a  
		INNER JOIN sys.schemas b
			ON a.schema_id = b.schema_id
	WHERE TYPE = 'FN'
	ORDER BY b.Name, a.Name

	OPEN curGrant

	FETCH NEXT FROM curGrant INTO @tSQL
	WHILE @@fetch_status = 0
		BEGIN
			--PRINT @tSQL
			EXEC SP_EXECUTESQL @tSQL
			FETCH NEXT FROM curGrant INTO @tSQL			
		END
CLOSE curGrant
DEALLOCATE curGrant

END
/*
SELECT * FROM sys.tables WHERE TYPE = 'u'
SELECT * FROM sys.views
SELECT * FROM sys.procedures
SELECT * FROM sys.objects WHERE TYPE = 'FN'
SELECT * FROM sys.schemas

	--	spRestoreGrants
*/
go
