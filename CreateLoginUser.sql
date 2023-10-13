USE master
GO

ALTER DATABASE Newton SET SINGLE_USER WITH ROLLBACK IMMEDIATE
GO
WAITFOR DELAY '00:00:01';
print 1
go
ALTER DATABASE Newton SET DISABLE_BROKER WITH ROLLBACK IMMEDIATE
GO
WAITFOR DELAY '00:00:01';
print 2
go
ALTER DATABASE EA SET SINGLE_USER WITH ROLLBACK IMMEDIATE
go
WAITFOR DELAY '00:00:01';
print 3
GO
ALTER DATABASE EA SET DISABLE_BROKER WITH ROLLBACK IMMEDIATE
go
WAITFOR DELAY '00:00:01';
print 4
GO
/*

General Purpose:
Create SQL Login and database user

Update History of this script:
Date Modified	Author:		Version:	Reason

Tip:  Use find replace (ctrl + h) to replace parameters marked with <> as needed.

select * from Newton.dbo.usysVersion order by versionID desc

Database Name:			Newton
Scheme Name:			dbo
Date Created:			20090729   Format:  yyyymmdd
Author:					Bhavesh
Tested By:  			Bhavesh

*/

USE Newton
GO

-- **********************    END OF FILE HEADER     **************************
GO

IF  EXISTS (SELECT * FROM sys.server_principals WHERE name = N'WebAppsUserNewton6281')
DROP LOGIN WebAppsUserNewton6281
GO
EXEC sp_addlogin 'WebAppsUserNewton6281', 'h:=L-Zn]bJ87'
GO

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'WebAppsUser')
DROP USER WebAppsUser
GO
CREATE USER WebAppsUser FOR LOGIN WebAppsUserNewton6281
GO
EXEC sp_addrolemember N'db_owner', N'WebAppsUser'
GO
/*

USE EA
GO

IF  EXISTS (SELECT * FROM sys.database_principals WHERE name = N'WebAppsUser')
DROP USER WebAppsUser
GO
CREATE USER WebAppsUser FOR LOGIN WebAppsUserNewton6281
GO
EXEC sp_addrolemember N'db_owner', N'WebAppsUser'
GO
-- **************   END OF SCRIPT ***************************************
-- drop connection to db for quick restoring
*/
use master
GO

ALTER DATABASE Newton SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE Newton SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE EA SET ENABLE_BROKER WITH ROLLBACK IMMEDIATE
GO
ALTER DATABASE EA SET MULTI_USER WITH ROLLBACK IMMEDIATE
GO