create proc spSendAlertMail
as
declare @body1 varchar(100)
set @body1 = 'Server :'+@@servername+ ' My First Database Email '
EXEC msdb.dbo.sp_send_dbmail @recipients='kalpesh@xeosoftware.com',
    @subject = 'CPU Utilization of '+@@servername+' reached above',
    @body = @body1,
    @body_format = 'HTML'