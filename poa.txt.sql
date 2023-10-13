select getdate()
care_date -scope date
change_date pperiod where clause

--2009-07-15 09:12:37.020
/*

sp
_0. off_code in joins
1. generate script for inser/update/delete to test trigger.
_2. Implement the Compare To feature.  For that, take the compare to dates, and filter on the Care_Date on the visit table.  
You’ll get one number per office, total income (or hours) for each office for the entire period.  Those will be 4 flat lines on the graph.  
In fact, you could keep the lines the same color.

USR2
Data import and deletion of data

*/

--2009-07-14 10:16:04.257
-----------------------
/*NO IDEA


trigger
_1. Insert baseline records.  Basically, we must delete all the data in the history table.  Then, we must fire the insert statement for every visit as if every visit was just inserted into the system.  In this way, we’ll establish a base-line data so the numbers would not start at 0.
_2. Kalpesh:  Why do we have history records where the incomeDelta = 0?  I believe every history record would have IncomeDelta <> 0.  Please advise.


sp
_1. Drop the admin office.  This office will never have any visits.
2. Implement the Compare To feature.  For that, take the compare to dates, and filter on the Care_Date on the visit table.  You’ll get one number per office, total income (or hours) for each office for the entire period.  Those will be 4 flat lines on the graph.  In fact, you could keep the lines the same color.
_3. The Y Axis Unit should also allow the user to select Income.  Make income the default.  This drop-down list indicates which number (hours v. income) we sum.
_4. Alphabetize the lists.


Front End
1.The date/time at the top is not accurate.
2. Drop the sales rep and location graphs.  We’ll just show the office graph.  Just hide the other graphs for now.  Once we get further into the project, we’ll refractor the code and make it more simple.  Please do also comment the code that populates the referral and sales rep tables.  
3. Add an “All” Check box at the top of the 3 checkbox lists.  When the page displays, this All would be checked by default.  Actually, I’m thinking the ALL option would be above the check box lists, not in the lists.  The list would be disabled so long as the ALL was checked.  Once the user unchecked all, they could check various offices, / sales rep or referrals.  Only consider change records that are in the where clause. 
*/


CROSS APPLY 
(
	SELECT sum(isnull(NewHours,0))  Hr
	FROM SAM.idb.tblVisitHistory
	WHERE care_date BETWEEN @CompareStartDate AND @CompareEndDate
		AND 
		off_name = a.off_name
) CompareHr
CROSS APPLY 
(
	SELECT sum(isnull(NewIncome,0)) Amt
	FROM SAM.idb.tblVisitHistory 
	WHERE care_date BETWEEN @CompareStartDate AND @CompareEndDate
		AND 
		off_name = a.off_name
) CompareAmt


--2009-07-29 10:56:00.990
/*
BSD
Create Database
Create Tables and SPs

Carenet
1. Data matching
2. SP for graphs

Viewstate

*/