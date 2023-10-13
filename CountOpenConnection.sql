sp_who
select spid,hostname,loginame,cmd,db_name(dbid) as dbname, status
from master.dbo.sysprocesses 
where datediff(dd,login_time,getdate()) = 0
order by hostname

SELECT SPID,
          STATUS,
          PROGRAM_NAME,
       LOGINAME=RTRIM(LOGINAME),
          HOSTNAME,
          CMD
FROM  MASTER.DBO.SYSPROCESSES
WHERE DBID <> 0 

SELECT DB_NAME(dbid) as 'DbNAme', COUNT(dbid) as 'Connections' from master.dbo.sysprocesses with (nolock)
WHERE dbid > 0
GROUP BY dbid

Select * from sys.dm_tran_locks
