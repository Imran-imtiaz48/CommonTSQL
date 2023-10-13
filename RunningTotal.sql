CREATE TABLE Sales (DayCount smallint, Sales money)
CREATE CLUSTERED INDEX ndx_DayCount ON Sales(DayCount)
go
INSERT Sales VALUES (1,120)
INSERT Sales VALUES (2,60)
INSERT Sales VALUES (3,125)
INSERT Sales VALUES (4,40)

DECLARE @DayCount smallint, @Sales money
SET @DayCount = 5
SET @Sales = 10

WHILE @DayCount < 5000
 BEGIN
  INSERT Sales VALUES (@DayCount,@Sales)
  SET @DayCount = @DayCount + 1
  SET @Sales = @Sales + 15
 END

 SELECT DayCount,
       Sales,
       Sales+COALESCE((SELECT SUM(Sales) FROM Sales b WHERE b.DayCount < a.DayCount),0)
                         AS RunningTotal
FROM Sales a
ORDER BY DayCount