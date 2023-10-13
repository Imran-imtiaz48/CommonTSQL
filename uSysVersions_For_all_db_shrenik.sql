USE Master
go

SELECT 'SELECT '''+name +' '' DBName, SettingID, ScrubDateTime FROM '+name+'.dbo.usysSetting union all' 
from sys.Databases

/*
SELECT * FROM 
(
SELECT 'Timesheets ' DBName, SettingID, ScrubDateTime FROM Timesheets.dbo.usysSetting union all
SELECT 'Newton ' DBName, SettingID, ScrubDateTime FROM Newton.dbo.usysSetting union all
SELECT 'USR2 ' DBName, SettingID, ScrubDateTime FROM USR2.dbo.usysSetting union all
SELECT 'IRG ' DBName, SettingID, ScrubDateTime FROM IRG.dbo.usysSetting union all
SELECT 'IDBMaintenance ' DBName, SettingID, ScrubDateTime FROM IDBMaintenance.dbo.usysSetting union all
SELECT 'USCC ' DBName, SettingID, ScrubDateTime FROM USCC.dbo.usysSetting union all
SELECT 'MRS ' DBName, SettingID, ScrubDateTime FROM MRS.dbo.usysSetting union all
SELECT 'TimesheetsDemo ' DBName, SettingID, ScrubDateTime FROM TimesheetsDemo.dbo.usysSetting

)A
Order by ScrubDateTime
*/