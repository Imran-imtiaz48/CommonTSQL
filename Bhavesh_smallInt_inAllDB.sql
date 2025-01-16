/* Resolving Collation Issue */

DECLARE @NL CHAR(2);
SET @NL = CHAR(13) + CHAR(10);

-- Generate the query dynamically for all databases
SELECT 
    'SELECT d.name, t.table_schema, t.table_name, c.column_name, c.data_type' +
    @NL + 'FROM sys.databases d' +
    @NL + 'JOIN ' + QUOTENAME(d.name) + '.information_schema.tables t' +
    @NL + ' ON d.name COLLATE DATABASE_DEFAULT = t.table_catalog COLLATE DATABASE_DEFAULT' +
    @NL + 'JOIN ' + QUOTENAME(d.name) + '.information_schema.columns c' +
    @NL + ' ON t.table_catalog COLLATE DATABASE_DEFAULT = c.table_catalog COLLATE DATABASE_DEFAULT' +
    @NL + ' AND t.table_schema = c.table_schema' +
    @NL + ' AND t.table_name = c.table_name' +
    @NL + 'WHERE c.data_type = ''smallint''' + @NL + @NL
FROM sys.databases d;
