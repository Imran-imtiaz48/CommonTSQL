USE Swit;
GO
SET NOCOUNT ON;

-- Temporary Table to Store Index Fragmentation Data
IF OBJECT_ID('tempdb..#IndexFragmentation') IS NOT NULL
    DROP TABLE #IndexFragmentation;

CREATE TABLE #IndexFragmentation (
    DBName NVARCHAR(128),
    DatabaseID INT,
    ObjectID INT,
    IndexID INT,
    SchemaName NVARCHAR(128),
    TableName NVARCHAR(128),
    IndexName NVARCHAR(128),
    AvgFragmentationPercent FLOAT,
    RowCounts BIGINT
);

-- Insert Fragmented Index Data
INSERT INTO #IndexFragmentation
SELECT 
    db.name AS DBName, 
    ps.database_id, 
    ps.object_id,
    ps.index_id, 
    sc.name AS SchemaName,
    ob.name AS TableName, 
    idx.name AS IndexName, 
    ps.avg_fragmentation_in_percent, 
    p.rows AS RowCounts
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, 'LIMITED') AS ps
JOIN sys.indexes AS idx 
    ON ps.object_id = idx.object_id AND ps.index_id = idx.index_id
JOIN sys.objects AS ob 
    ON ob.object_id = idx.object_id
JOIN sys.schemas AS sc 
    ON ob.schema_id = sc.schema_id
JOIN sys.databases AS db 
    ON ps.database_id = db.database_id
JOIN sys.partitions AS p 
    ON ps.object_id = p.object_id AND ps.index_id = p.index_id
WHERE ps.database_id = DB_ID()
AND ps.avg_fragmentation_in_percent > 70;

-- Display Fragmented Indexes
SELECT * 
FROM #IndexFragmentation
ORDER BY AvgFragmentationPercent DESC;

-- Count Indexes Per Table
SELECT 
    db.name AS DBName, 
    sc.name AS SchemaName, 
    ob.name AS TableName, 
    COUNT(idx.name) AS IndexCount
FROM sys.indexes AS idx
JOIN sys.objects AS ob 
    ON ob.object_id = idx.object_id
JOIN sys.schemas AS sc 
    ON ob.schema_id = sc.schema_id
JOIN sys.databases AS db 
    ON db.database_id = DB_ID()
WHERE ob.type = 'U'
GROUP BY db.name, sc.name, ob.name
ORDER BY IndexCount DESC;

-- Cleanup
DROP TABLE #IndexFragmentation;
