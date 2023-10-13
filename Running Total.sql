use Vault
go
SELECT PartID--, orderid, orderdate, val
, subclassIDF, basecost
, SUM(basecost) OVER(PARTITION BY subclassIDF ORDER BY partID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS runningtotal
FROM tblPart
where basecost <> 0
Order by subclassIDF