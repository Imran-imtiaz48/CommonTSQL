USE Master
go

--enable the Database Mail feature on the server
sp_configure 'show advanced options',1
go
reconfigure with override
go
sp_configure 'Database Mail XPs',1
go
reconfigure 
go

--The Configuration Component Database account
EXECUTE msdb.dbo.sysmail_add_account_sp
    @account_name = 'MyMailAccount',
    @description = 'Mail account for Database Mail',
    @email_address = 'kalpesh@idb.bz',
    @display_name = 'MyAccount',
	--@username='kalpesh@idb.bz',
	--@password='',
	--@port=465,
	--@enable_ssl = 1,	
    @mailserver_name = 'localhost'


--create a Mail profile.
EXECUTE msdb.dbo.sysmail_add_profile_sp
       @profile_name = 'MyMailProfile',
       @description = 'Profile used for database mail'

--add the Database Mail account
EXECUTE msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'MyMailProfile',
    @account_name = 'MyMailAccount',
    @sequence_number = 1

--grant the Database Mail profile access to the msdb public database role and to make the profile the default Database Mail profile
EXECUTE msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'MyMailProfile',
    @principal_name = 'public',
    @is_default = 1 ;

--send a test email from SQL Server. 
   
declare @body1 varchar(100)
set @body1 = 'Server :'+@@servername+ ' My First Database Email '
EXEC msdb.dbo.sp_send_dbmail @recipients='kalpesh@xeosoftware.com',
    @subject = 'CPU Utilization of',
    @body = @body1,
    @body_format = 'HTML'

/*
Select * from msdb.dbo.sysmail_profile    
Select * from msdb.dbo.sysmail_principalprofile
Select * from msdb.dbo.sysmail_account

Delete msdb.dbo.sysmail_profile
Delete msdb.dbo.sysmail_principalprofile
Delete msdb.dbo.sysmail_account
*/