USE Vault
GO
--SlickOSAccountProductRule
SELECT distinct --syscomments.id, 
'EXEC sp_helptext ' + SysObjects.name  + ';'
--, SysObjects.xtype
--+ CHAR(10)+CHAR(13)+'
--+' go'
 --'PRINT OBJECT_DEFINITION('+cast(SysObjects.id as varchar)+');'-- + CHAR(10)+CHAR(13)

FROM [syscomments], SysObjects 
where text like '%spServiceRequestCleanDataOnID%'
and syscomments.id = sysobjects.id
--ORDER BY 2
GO
--EXEC sp_helptext spSearchMemberSafeTravels;
--EXEC sp_helptext spAssociateJobWithWorkOrder;
--EXEC sp_helptext spMilesPerGallonReport;

--EXEC sp_helptext spGetRemedialServiceListOnOnTaskID;
--SELECT --sp.name, 
--	ISNULL(smsp.definition, ssmsp.definition) AS [Definition]
--FROM
--sys.all_objects AS sp
--LEFT OUTER JOIN sys.sql_modules AS smsp ON smsp.object_id = sp.object_id
--LEFT OUTER JOIN sys.system_sql_modules AS ssmsp ON ssmsp.object_id = sp.object_id
--WHERE (sp.type = 'P' OR sp.type = 'RF' OR sp.type='PC')
--and(sp.name like 'aspnet%' and SCHEMA_NAME(sp.schema_id)='dbo')





--sp_helptext spReportDeliveryTag

--select @variable_with_long_text as [processing-instruction(x)] FOR XML PATH 

SELECT * FROM INFORMATION_SCHEMA.COLUMNS where COLUMN_NAME like  '%Percent%' and TABLE_NAME like 'tbl%'
/*
sp_helptext 'dbo.spJobUpdateMemberPriceSchedule'
go
sp_helptext 'dbo.spmembershipdays'
go
sp_helptext 'dbo.spDeleteAccountNumForTrans'
go
sp_helptext 'dbo.spProspectDropDuplicate'
go
sp_helptext 'Contact.spAddressPhoneDeleteOrphan'
go
sp_helptext 'dbo.spJobMemberSourceOverwrite'
go
sp_helptext 'dbo.spPopulatePaperlessTrend'

*/



/*
open transactions with text and plans

https://www.sqlskills.com/blogs/paul/script-open-transactions-with-text-and-plans/

SELECT
    [s_tst].[session_id],
    [s_es].[login_name] AS [Login Name],
    DB_NAME (s_tdt.database_id) AS [Database],
    [s_tdt].[database_transaction_begin_time] AS [Begin Time],
    [s_tdt].[database_transaction_log_bytes_used] AS [Log Bytes],
    [s_tdt].[database_transaction_log_bytes_reserved] AS [Log Rsvd],
    [s_est].text AS [Last T-SQL Text],
    [s_eqp].[query_plan] AS [Last Plan]
FROM
    sys.dm_tran_database_transactions [s_tdt]
JOIN
    sys.dm_tran_session_transactions [s_tst]
ON
    [s_tst].[transaction_id] = [s_tdt].[transaction_id]
JOIN
    sys.[dm_exec_sessions] [s_es]
ON
    [s_es].[session_id] = [s_tst].[session_id]
JOIN
    sys.dm_exec_connections [s_ec]
ON
    [s_ec].[session_id] = [s_tst].[session_id]
LEFT OUTER JOIN
    sys.dm_exec_requests [s_er]
ON
    [s_er].[session_id] = [s_tst].[session_id]
CROSS APPLY
    sys.dm_exec_sql_text ([s_ec].[most_recent_sql_handle]) AS [s_est]
OUTER APPLY
    sys.dm_exec_query_plan ([s_er].[plan_handle]) AS [s_eqp]
ORDER BY
    [Begin Time] ASC;
GO
*/


--Full text search index
/*
SELECT 
    t.name AS TableName, 
    c.name AS FTCatalogName ,
    i.name AS UniqueIdxName,
    cl.name AS ColumnName
FROM 
    sys.tables t 
INNER JOIN 
    sys.fulltext_indexes fi 
ON 
    t.[object_id] = fi.[object_id] 
INNER JOIN 
    sys.fulltext_index_columns ic
ON 
    ic.[object_id] = t.[object_id]
INNER JOIN
    sys.columns cl
ON 
        ic.column_id = cl.column_id
    AND ic.[object_id] = cl.[object_id]
INNER JOIN 
    sys.fulltext_catalogs c 
ON 
    fi.fulltext_catalog_id = c.fulltext_catalog_id
INNER JOIN 
    sys.indexes i
ON 
        fi.unique_index_id = i.index_id
    AND fi.[object_id] = i.[object_id];
	*/

	--JobSplits
	--spUSPSDashboard
	--vJobHeadline
	--vJobsERT


	

/*
INSERT INTO dbo.QBSyncObject(ObjectName,ObjectID,Active)
SELECT QBSyncObjectName, ltrim(rtrim(ObjectID)) ObjectID,1 Active
FROM
(
	Select  'Company' QBSyncObjectName , 1017 ObjectID	
	union 
	Select 'Account',3045 val 	

) A;
*/
