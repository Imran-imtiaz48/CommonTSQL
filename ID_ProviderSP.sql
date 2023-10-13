--A Simple Example of Contained Databases
Use vault
go
create proc spIDProvider
as
/*

Select TABLE_SCHEMA, TABLE_NAME 
from INFORMATION_SCHEMA.TABLES 
where TABLE_SCHEMA= 'dbo' and TABLE_NAME like 'tbl%'
order by table_name

Select distinct TABLE_SCHEMA  from INFORMATION_SCHEMA.TABLES 
*/
--Select * from INFORMATION_SCHEMA
--Declare @tempTable table (t_sql varchar(max))

--Delete from usysIDProvider
declare @tempTable as table(tsql1  varchar(500))
delete from usysIDProvider

insert into @tempTable
select 'INSERT INTO [dbo].[usysIDProvider] SELECT ''' + TABLE_SCHEMA + '_' + SUBSTRING(TABLE_NAME, 4,99) + ''', ISNULL(MAX(' + SUBSTRING(TABLE_NAME, 4, 99) + 'ID),1) from ' + TABLE_SCHEMA + '.' + TABLE_NAME + ' GO '   tsql1
from 
(
Select tb.TABLE_SCHEMA, tb.TABLE_NAME 
from INFORMATION_SCHEMA.TABLES  tb
	INNER JOIN INFORMATION_SCHEMA.COLUMNS  cl
		ON tb.TABLE_NAME = cl.TABLE_NAME AND COLUMN_NAME = SUBSTRING(tb.TABLE_NAME, 4,99) + 'ID'
where tb.TABLE_SCHEMA= 'dbo' and tb.TABLE_NAME like 'tbl%'
group by tb.TABLE_SCHEMA, tb.TABLE_NAME 
--order by table_name
) a
--Select * from @tempTable
--drop table @tempTable
--select 'INSERT INTO [dbo].[usysIDProvider] SELECT ''' + sc + '_' + SUBSTRING(tb, 4,99) + ''', ISNULL(MAX(' + SUBSTRING(tb, 4, 99) + 'ID),1) from ' + sc + '.' + tb + ' GO ' RAM INTO @tempTable2
--from @tempTable

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
exec spIDProvider

Select * from usysIDProvider