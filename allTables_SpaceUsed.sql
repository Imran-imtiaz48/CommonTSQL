CREATE PROCEDURE dbo.allTables_SpaceUsed 
AS 
BEGIN 
    SET NOCOUNT ON      
 
    DBCC UPDATEUSAGE(0) 
 
    CREATE TABLE #t 
    ( 
        id INT, 
        TableName VARCHAR(32), 
        NRows INT, 
        Reserved FLOAT, 
        TableSize FLOAT, 
        IndexSize FLOAT, 
        FreeSpace FLOAT 
    ) 
 
    INSERT #t EXEC sp_msForEachTable 'SELECT 
        OBJECT_ID(PARSENAME(''?'',1)), 
        PARSENAME(''?'',1), 
        COUNT(*),0,0,0,0 FROM ?' 
 
    DECLARE @low INT 
 
    SELECT @low = [low] FROM master.dbo.spt_values 
        WHERE number = 1 
        AND type = 'E' 
 
    UPDATE #t SET Reserved = x.r, IndexSize = x.i FROM 
        (SELECT id, r = SUM(si.reserved), i = SUM(si.used) 
        FROM sysindexes si 
        WHERE si.indid IN (0, 1, 255) 
        GROUP BY id) x 
        WHERE x.id = #t.id 
 
    UPDATE #t SET TableSize = (SELECT SUM(si.dpages) 
        FROM sysindexes si 
        WHERE si.indid < 2 
        AND si.id = #t.id) 
 
    UPDATE #t SET TableSize = TableSize + 
        (SELECT COALESCE(SUM(used), 0) 
        FROM sysindexes si 
        WHERE si.indid = 255 
        AND si.id = #t.id) 
 
    UPDATE #t SET FreeSpace = Reserved - IndexSize 
 
    UPDATE #t SET IndexSize = IndexSize - TableSize 
 
    SELECT 
        tablename, 
        nrows, 
        Reserved = LTRIM(STR( 
            reserved * @low / 1024.,15,0) + 
            ' ' + 'KB'), 
        DataSize = LTRIM(STR( 
            tablesize * @low / 1024.,15,0) + 
            ' ' + 'KB'), 
        IndexSize = LTRIM(STR( 
            indexSize * @low / 1024.,15,0) + 
            ' ' + 'KB'), 
        FreeSpace = LTRIM(STR( 
            freeSpace * @low / 1024.,15,0) + 
            ' ' + 'KB') 
        FROM #t 
        ORDER BY 1 
 
    DROP TABLE #t 
END