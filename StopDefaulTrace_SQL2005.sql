--SELECT * FROM fn_trace_geteventinfo (1)
SP_CONFIGURE
go
--show advanced option, make it true for default trace 
EXEC sp_configure 'show advanced options', 1
go
RECONFIGURE
GO
--disable default trace 
EXEC sp_configure 'default trace enabled', 0;
GO
RECONFIGURE;
GO
--hide advanced option
EXEC sp_configure 'show advanced option', 0;
GO
RECONFIGURE;
GO
SP_CONFIGURE
--SELECT * FROM sys.configurations