/* COLLATION ISSUE AT THE BOTTOM IS DUE*/

DECLARE @NL CHAR(2)
SET @NL = CHAR(13) + CHAR(10)

select 'select d.name, t.table_schema, t.table_name, c.column_name, c.data_type' +
@NL + 'from sys.databases d' +
@NL + 'join ' + d.name + '.information_schema.tables t' +
@NL + ' on d.name = t.table_catalog' +
@NL + 'join ' + d.name + '.information_schema.columns c' +
@NL + ' on t.table_catalog = c.table_catalog' +
@NL + ' and t.table_schema = c.table_schema' +
@NL + ' and t.table_name = c.table_name' +
@NL + 'where data_type = ''smallint''' + @NL + @NL
from sys.databases d
/*Msg 468, Level 16, State 9, Line 1
Cannot resolve the collation conflict between "Latin1_General_CI_AS_KS_WS" and "SQL_Latin1_General_CP1_CI_AS" in the equal to operation.
*/

