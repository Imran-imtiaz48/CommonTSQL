Select 'DBCC SHRINKDATABASE(' + name +',7)' From sys.databases Where Database_ID > 4

DBCC SHRINKDATABASE(IRG,10)

use IRG
go
DBCC SHRINKFILE('IRG_log', truncate_only)

Select * from sys.databases where is_auto_close_on = 1

HP NC7781 Gigabit Server Adapter: The network link is down.  Check to make sure the network cable is properly connected.
HP NC7781 Gigabit Server Adapter: Network controller configured for 100Mb full-duplex link.

USE IRG
GO
DBCC SHRINKFILE('IRG_log', 1)
BACKUP LOG IRG WITH TRUNCATE_ONLY
DBCC SHRINKFILE('IRG_log', 1)

sp_spaceused
--Select 934392/1024