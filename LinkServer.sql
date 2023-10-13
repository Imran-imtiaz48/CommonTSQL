
EXEC master.dbo.sp_addlinkedserver @server = N'H2', @srvproduct=N'hunk', @provider=N'SQLNCLI', @datasrc=N'hunk\sqlexpress', @catalog=N'newton'
 
EXEC master.dbo.sp_addlinkedsrvlogin @rmtsrvname=N'H2',@useself=N'True',@locallogin=NULL,@rmtuser=NULL,@rmtpassword=NULL

GO
