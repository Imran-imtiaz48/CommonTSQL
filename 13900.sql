USE Master;
GO

-- Enable the Database Mail feature on the server
EXEC sp_configure 'show advanced options', 1;
GO
RECONFIGURE WITH OVERRIDE;
GO
EXEC sp_configure 'Database Mail XPs', 1;
GO
RECONFIGURE;
GO

-- Configure the Database Mail account
EXEC msdb.dbo.sysmail_add_account_sp
    @account_name = 'MyMailAccount',
    @description = 'Mail account for Database Mail',
    @email_address = 'kalpesh@idb.bz',
    @display_name = 'MyAccount',
    -- Uncomment and configure the following lines for secure authentication, if required
    -- @username = 'your_username',
    -- @password = 'your_password',
    -- @port = 465,
    -- @enable_ssl = 1,  
    @mailserver_name = 'localhost';

-- Create a Database Mail profile
EXEC msdb.dbo.sysmail_add_profile_sp
    @profile_name = 'MyMailProfile',
    @description = 'Profile used for Database Mail';

-- Add the Database Mail account to the profile
EXEC msdb.dbo.sysmail_add_profileaccount_sp
    @profile_name = 'MyMailProfile',
    @account_name = 'MyMailAccount',
    @sequence_number = 1;

-- Grant access to the Database Mail profile and set it as the default
EXEC msdb.dbo.sysmail_add_principalprofile_sp
    @profile_name = 'MyMailProfile',
    @principal_name = 'public',  -- Assign access to the public role
    @is_default = 1;

-- Send a test email from SQL Server
DECLARE @EmailBody NVARCHAR(200);
SET @EmailBody = 'Server: ' + @@SERVERNAME + ' - My First Database Email';

EXEC msdb.dbo.sp_send_dbmail 
    @recipients = 'kalpesh@xeosoftware.com',
    @subject = 'CPU Utilization Notification',
    @body = @EmailBody,
    @body_format = 'HTML';

-- Optional: Query the Database Mail system tables to verify configurations
-- SELECT * FROM msdb.dbo.sysmail_profile;
-- SELECT * FROM msdb.dbo.sysmail_principalprofile;
-- SELECT * FROM msdb.dbo.sysmail_account;

-- Uncomment the following lines if you need to delete Database Mail configurations
-- DELETE FROM msdb.dbo.sysmail_profile;
-- DELETE FROM msdb.dbo.sysmail_principalprofile;
-- DELETE FROM msdb.dbo.sysmail_account;
