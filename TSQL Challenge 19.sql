declare @emp TABLE (
	EmployeeID INT,
	FirstName VARCHAR(15),
	LastName VARCHAR(15),
	ReportsTo INT
)

declare @ord TABLE (
	OrderID INT,
	EmployeeID INT
)

INSERT INTO @emp(EmployeeID, FirstName, LastName, ReportsTo)
SELECT 2,'Andrew','Fuller',NULL UNION ALL
SELECT 1,'Nancy','Davolio',2 UNION ALL
SELECT 3,'Janet','Leverling',2 UNION ALL
SELECT 4,'Margaret','Peacock',2 UNION ALL
SELECT 5,'Steven','Buchanan',2 UNION ALL
SELECT 8,'Laura','Callahan',2 UNION ALL
SELECT 6,'Michael','Suyama',5 UNION ALL
SELECT 7,'Robert','King',5 UNION ALL
SELECT 9,'Anne','Dodsworth',5
INSERT INTO @ord (OrderID, EmployeeID) 
SELECT 10258,1 UNION ALL
SELECT 10270,1 UNION ALL
SELECT 10275,1 UNION ALL
SELECT 10265,2 UNION ALL
SELECT 10277,2 UNION ALL
SELECT 10251,3 UNION ALL
SELECT 10253,3 UNION ALL
SELECT 10256,3 UNION ALL
SELECT 10250,4 UNION ALL
SELECT 10252,4 UNION ALL
SELECT 10248,5 UNION ALL
SELECT 10254,5 UNION ALL
SELECT 10249,6 UNION ALL
SELECT 10289,7 UNION ALL
SELECT 10303,7 UNION ALL
SELECT 10308,7 UNION ALL
SELECT 10262,8 UNION ALL
SELECT 10268,8 UNION ALL
SELECT 10276,8 UNION ALL
SELECT 10278,8 UNION ALL
SELECT 10255,9 UNION ALL
SELECT 10263,9 


;WITH cte AS
(
	SELECT LastName + ' ' + FirstName Employee_NM, EmployeeID, ReportsTo, 0 AS Lvl
	FROM @emp
	WHERE ReportsTo IS NULL

	UNION ALL

	SELECT p.LastName + ' ' + p.FirstName Employee_NM, p.EmployeeID, p.ReportsTo, A.lvl + 1
	FROM @emp p
		INNER JOIN cte A 
			ON A.EmployeeID = P.ReportsTo
)

/*
;WITH cte AS (
    SELECT 0 AS Lvl, EmployeeID, Employee_NM
    FROM @emp 
	WHERE ReportsTo IS NULL
    UNION ALL
    SELECT p.lvl + 1, c.EmployeeID, c.Employee_NM 
    FROM @emp c
    INNER JOIN cte p ON p.EmployeeID = c.ReportsTo
)*/

SELECT lvl Level,
    SPACE(lvl * 4) + Employee_NM AS Hierarchy, EmployeeID, ReportsTo
FROM cte
