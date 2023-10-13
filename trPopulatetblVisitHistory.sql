SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author		:	Kalpesh Patel
-- Create date	:	2009-06-25 20:40:22.517
-- Description	:	Popilate date in this table on Insert/Update/Delete events on the visit table
-- =============================================

ALTER TRIGGER trPopulatetblVisitHistory
   ON visit after INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
    -- Insert statements for trigger here
	--SELECT * FROM Inserted
	--Single or multiple record inserted at a time
	--

/*Insert into tblVisitHistory(VisitHistoryID, ChangeDateTime, off_code, off_name, Location, LocationDescr, referral_no, Referral_Name,
	client_no, admit_no, care_date, NewIncome, IncomeDelta, OldVisit_Stat, NewVisit_Stat, OldHours, NewHours, HoursDelta, OldBill_Unit, 
	NewBill_Unit, OldBill_Rate, NewBill_Rate,  foreign_primekey)*/
Select  order_no, visit_no, visit_stat, compliance, emp_no, payer_set, client_no, admit_no, care_date,
from_time, to_time, spec_hours, hours, pay_unit, bill_unit, sub_unit, reg_rate, reg_hrs, other_pay,
bill_rate, pay_trans, bill_trans, super_vis, pay_over, bill_over, from_break, to_break, assessment,
skill, sub_skill, skill_cat, off_code, user_id, tstamp, primekey, payrolled, sales_tax, alreadypaid,
bill_no, serv_loc, payclass, paysubc, trans_date, payer_seto, fromtpv, miles
From Inserted

END
GO


