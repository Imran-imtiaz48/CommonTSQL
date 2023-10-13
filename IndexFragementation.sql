USE Swit
go
SELECT db.Name DBName, ps.database_id, ps.OBJECT_ID,
ps.index_id, ob.Name TableName, b.name IndexName, ps.avg_fragmentation_in_percent, RowCnt.RowCounts
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
	INNER JOIN sys.indexes AS b 
		ON ps.OBJECT_ID = b.OBJECT_ID AND ps.index_id = b.index_id
	INNER JOIN sys.databases AS db 
		ON ps.database_ID = db.database_ID
	INNER JOIN sys.objects AS ob 
		ON ob.Object_ID = b.Object_ID
	INNER JOIN 
	(
		SELECT so.name TableName, MAX(si.rows) RowCounts
		FROM sysobjects so, sysindexes si 
		WHERE so.xtype = 'U' AND si.id = OBJECT_ID(so.name) 
		GROUP BY so.name	
	) RowCnt
	ON ob.Name = RowCnt.TableName
WHERE ps.database_id = DB_ID()
and  ps.avg_fragmentation_in_percent > 70
ORDER BY ps.avg_fragmentation_in_percent desc




SELECT db.Name DBName, sc.Name SchemaName, ob.Name TableName, count(b.name)
FROM sys.dm_db_index_physical_stats (DB_ID(), NULL, NULL, NULL, NULL) AS ps
	INNER JOIN sys.indexes AS b 
		ON ps.OBJECT_ID = b.OBJECT_ID AND ps.index_id = b.index_id
	INNER JOIN sys.databases AS db 
		ON ps.database_ID = db.database_ID
	INNER JOIN sys.objects AS ob 
		ON ob.Object_ID = b.Object_ID
	INNER JOIN sys.schemas AS sc 
		ON ob.Schema_ID = sc.Schema_id
	INNER JOIN 
	(
		SELECT so.name TableName, MAX(si.rows) RowCounts
		FROM sysobjects so, sysindexes si 
		WHERE so.xtype = 'U' AND si.id = OBJECT_ID(so.name) 
		GROUP BY so.name	
	) RowCnt
	ON ob.Name = RowCnt.TableName
WHERE ps.database_id = DB_ID()
group by db.Name , ob.Name , sc.Name
ORDER BY count(b.name) desc



