USE master
GO
-- The OUTER keyword following the FULL keyword is optional.
Declare @Table1 table (T1C1 varchar(20), T1C2 varchar(20), T1C3 varchar(20))
Declare @Table2 table (T2C1 varchar(20), T2C2 varchar(20))

insert into @Table1 
Select '1', 'a', '1' union all
Select '2', 'b', null union all
Select '3', 'c', '2'


insert into @Table2
Select '1', 'a' union all
Select '2', 'b' union all
Select '3', 'c'

SELECT *
FROM @Table1 a1
FULL OUTER JOIN @Table2 a2
ON a1.T1C3 = a2.T2C1
--WHERE a1.T1C3 IS NULL or a2.T2C1 IS NULL


/*
USE AdventureWorks2008R2;
GO
-- The OUTER keyword following the FULL keyword is optional.
SELECT p.Name, sod.SalesOrderID
FROM Production.Product p
FULL OUTER JOIN Sales.SalesOrderDetail sod
ON p.ProductID = sod.ProductID
WHERE p.ProductID IS NULL
OR sod.ProductID IS NULL
ORDER BY p.Name ;
*/