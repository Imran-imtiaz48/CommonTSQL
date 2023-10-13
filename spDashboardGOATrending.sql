USE [USR2]
GO
ALTER PROC dbo.[spDashboardGOATrending]
(
	@StartDate DATETIME
	, @EndDate DATETIME
)
AS

/*
Purpose			:	GOA Trending
				Question: Are GOA incidents increasing as a percentage of Total incidents?
SRS Document	:	
Paragrahp		:
				
Date Created	:	20090417
Author			: 	Kalpesh
Tested by		:
Version			:

PARAMETER NOTES:
Update History:
Date Modified	Author:	Version:	Reason
*/

SELECT Total.Month
	, Total.Year
	, CAST(Total.Month AS VARCHAR)+ '-' + CAST(Total.Year AS VARCHAR) FullName
	, TotalIncidents
	, ISNULL(GOAIncidents,0) GOAIncidents
	, ISNULL(GOAIncidents,0) / CAST(TotalIncidents AS DECIMAL(9,2)) GOAPercentage
FROM
(   -- Count Total incidents per Month	
	SELECT Month(IncidentDateTime) Month
		, Year(IncidentDateTime) Year
		, count(*) TotalIncidents	
	FROM tblIncident
	WHERE IncidentDateTime BETWEEN @StartDate AND @EndDate
	GROUP BY Month(IncidentDateTime), Year(IncidentDateTime)
) Total	
LEFT JOIN
(		
	-- count # of GOA incidents per Month		
	SELECT Month(IncidentDateTime) Month, Year(IncidentDateTime) Year, count(*) GOAIncidents
	FROM tblIncident
	WHERE IncidentId in
		(	
			SELECT IncidentIDF
			FROM tblIncidentDetail
			WHERE ProductIDF = 8 -- SELECT Product FROM tblProduct WHERE productID = 8
		)
	AND
	IncidentDateTime BETWEEN @StartDate AND @EndDate
	GROUP BY Month(IncidentDateTime), Year(IncidentDateTime)		
) GOA
ON Total.Month = GOA.Month 
	AND
	Total.Year = GOA.Year
ORDER BY Year, Month

/*
	EXEC dbo.spDashboardGOATrending '1/1/2008','5/31/2008'
*/
GO