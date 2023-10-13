USe Newton
go

Create View vTest
as

Select *  from Temp
go

-------------------------------

Select * from vTest



Create proc spTest
(
	@FromDate as datetime
	,@ToDate as datetime
)
as
Select *  from Temp
Where Date between  @FromDate and @ToDate
go

exec spTest


Create table #Temp(a int)
Create table ##Temp(a int)

Select * from #Temp



Create function fncTest
as

Select *  from Temp

Where Date between  @FromDate and @ToDate
go

SELECT * FROM fncGetCycles()

