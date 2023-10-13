EXEC sp_dbcmptlevel 'assignment', '90';
go
ALTER AUTHORIZATION ON DATABASE::assignment TO sa
go
use [assignment]
go
EXECUTE AS USER = N'dbo' REVERT
go