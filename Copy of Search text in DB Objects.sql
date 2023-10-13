use irg
GO

SELECT distinct syscomments.id, SysObjects.name , SysObjects.xtype
FROM [syscomments], SysObjects 
where text like '%NumberOfSitesWithAtLeast1Part%'
and syscomments.id = SysObjects.id
order by 2

GO