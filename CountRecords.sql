DECLARE @strQry NVARCHAR(2000)
DECLARE @strTable VARCHAR(100)
declare @Records nvarchar(2000)
declare @iCnt as int
set @iCnt = 0
CREATE TABLE #temp(TableName varchar(100), Records DECIMAL)
INSERT INTO #temp (TableName) 

/*SELECT '['+Table_Schema +'].['+name + ']' 
FROM INFORMATION_SCHEMA.TABLES a inner join sys.Objects b on a.table_name = b.name
WHERE --a.Table_schema ='contact' AND 
	a.table_type='base table' AND 
	name like 'tbl%'*/
SELECT name FROM sysobjects WHERE xtype='u' ORDER BY name

DECLARE C1 CURSOR FOR
SELECT TableName FROM #temp
OPEN C1
FETCH NEXT FROM C1 INTO @strTable

WHILE @@FETCH_STATUS = 0
BEGIN
set @iCnt = @iCnt+1
SET @strQry = 'UPDATE #temp SET Records = (Select count(*) from [' +''+ @strTable + ']) WHERE TableName = '+'''' +@strTable +''''
--PRINT @strQry
--PRINT 'Select * from [' + @strTable +']'

/*Print '--' + ltrim(rtrim(str(@iCnt)))
PRINT 'SET IDENTITY_INSERT Dallas.dbo.['+ @strTable +'] ON '
PRINT 'INSERT INTO   Dallas.dbo.[' + @strTable +']'
PRINT 'SELECT * FROM SSU2.dbo.[' + @strTable +']'
PRINT 'SET IDENTITY_INSERT Dallas.dbo.['+ @strTable +'] OFF '
print ''
*/
EXEC SP_EXECUTESQL @strQry
FETCH NEXT FROM C1 INTO @strTable
END
CLOSE C1
DEALLOCATE C1
SELECT * FROM #temp Order By Records Desc
drop table #temp
--UPDATE #temp SET Records = (Select count(*) from FDB_RADIMGC4_NEW) WHERE TableName='FDB_RADIMGC4_NEW'

--SELECT name FROM sysobjects  WHERE name like  'tbl%' AND xtype='u' ORDER BY name
--Select * from sys.schemas
--Select * from Process.tblProcessRecord
--Select * from [Called in How?]