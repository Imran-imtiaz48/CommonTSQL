use Vault
go
--129277
select sr.ServiceRequestID,ServiceRequestStatusIDF, IRGnumber, srt.SrStatusDescription, sr.WorkcenterIDF,IsBillable, IsTerminal,   *
from tblServiceRequest sr
	inner join tblServiceRequestStatus srt on ServiceRequestStatusIDF = ServiceRequestStatusID
	inner join tblPart  part on sr.PartIDF = part.PartID
where ServiceRequestID in (1178899)
--where OrderIDF = 203397

--AND IsBillable<>1 AND IsTerminal <>1

--Select * from tblPrerequisitePart where DependentPartIDF  in (502898, 513581)

select TaskID,SrStatusDescription,sequence a,servicerequeststatusidf StatuIDF, WorkcenterIDF WC, IsBillable B, IsTerminal T,Indate, CompletedDate, CompletedByPersonIDF, CancelledByPersonIDF, CancelledDate,  QAViolationReported, QAViolationReportedByPersonIDF

from tbltask 
	inner join tblServiceRequestStatus on servicerequeststatusidf = servicerequeststatusid
where ServiceRequestIDF  in (375906)
--AND IsBillable<>1 AND IsTerminal <>1
order by a
--Select * from tblServiceRequestStatusHistory
--Select * from tblexcep

--DECLARE @SRs SRIDTableType--dlv 44277

--INSERT INTO @SRs
--Select 69341

--Select ServiceRequestIDF, ServiceRequestStatusIDF, ServiceRequestStatusDate, TaskID
--from [dbo].[fncServiceRequestStatusOnDate](@SRs, '05/30/2013')

--Select * from vSrWorkCenter where TaskID = 941457
--Select * from tblWorkflowexception where WorkFlowExceptionID= 941457
--tblWorkflowexception
--Select * from tblTask where TaskID = 5027061
/*
Select ServiceRequestIDF, count(*)
from tblTask
	inner join tblServiceRequestStatus
		on ServiceRequestStatusID  = ServiceRequestStatusIDF 
where IsException = 1
group by ServiceRequestIDF
having count(*)>1
Order by 2  desc
*/

/*
Select ServiceRequestID,IRGNumber, SUbClassName, PartID, SubCLassID
from tblServiceRequest
	inner join tblpart
		on PartID = PartIDF
	inner join tblSubClass
		on SubCLassID = SUbClassIDF
Where ServiceRequestID = 206569

Select tblTask.ServiceRequestStatusIDF,*
From tblServiceRequest
	inner join tblTask
		on  ServiceRequestID = ServiceRequestIDF
Where ServiceRequestID = 206569

Select * from tblServiceRequestStatus where PartIDF = 261530
Select * from tblServiceRequestStatus where SubClassIDF = 25  and isException = 0 and OrderTypeIDF = 1 and NORMALSequence < 90 oRDER BY NORMALSequence
Select * from tblServiceRequestStatus where SubClassIDF = 25  and isException = 0 and OrderTypeIDF = 4 and NORMALSequence < 90 oRDER BY NORMALSequence

Select ServicerequestIDF,count(*)
from tblTask
Where Sequence in (97,96)
Group by ServicerequestIDF
having count(*)>2




select sr.ServiceRequestID,ServiceRequestStatusIDF, srt.SrStatusDescription, sr.WorkcenterIDF,IsBillable, IsTerminal,   o.OrderTypeIDF,  srt.OrderTypeIDF,   *
from tblServiceRequest sr
	inner join tblServiceRequestStatus srt on ServiceRequestStatusIDF = ServiceRequestStatusID
	inner join tblOrder o on OrderID = OrderIDF
where ServiceRequestID in (720998)


Select st.SiteTypeName,  * 
from tblSOWEnabler sow
	inner join tblSiteType st
		on sow.SiteTypeIDF = st.SiteTypeID 
where 
--SiteTypeName = 'SITE WIRELINE REACTIVE' and 
st.StatementOfWorkIDF  in (Select StatementOfWorkIDF from tblAccount where AccountID = 1000000049)
and SOWEnablerName = 'Secondary'

Select st.SiteTypeID,st.SiteTypeName,  sr.AccountIDF,  sEnb.* 
 From tblServiceRequest sr
  inner join tblAccount acc on acc.AccountID = sr.AccountIDF
  inner join tblSiteType st on st.StatementOfWorkIDF = acc.StatementOfWorkIDF --and st.SiteTypeName = 'STORES'
  inner join tblSOWEnabler sEnb on sEnb.SiteTypeIDF = st.SiteTypeID and senb.EnablerRoleIDF = 2
 Where sr.ServiceRequestID = 741064



Select ord.OrderID,  SiteType.SiteTypeID, SiteType.SiteTypeName, SOWEnabler.SOWEnablerID, SOWEnabler.SOWEnablerName 
from tblOrder ord
	inner join tblSiteType SiteType
		on ord.SiteTypeIDF = SiteType.SiteTypeID
	inner join tblSOWEnabler SOWEnabler
		on SiteType.SiteTypeID = SOWEnabler.SiteTypeIDF
where ord.OrderID = 137519


--fncSelectAvailableSPRIDOnAccountIDPartID

Select * From tblServiceRequestStatus where PartIDF = 259202 and OrderTypeIDF = 2 and  IsException = 0
Select * From tblServiceRequestStatus where SubClassIDF = 162 and OrderTypeIDF = 1 and  IsException = 0
Select PartIDF, OrderTypeIDF, NormalSequence From tblServiceRequestStatus where SrStatusDescription = 'Pending DR Confirmation' and SubClassIDF IS null
Select SubClassIDF, OrderTypeIDF, NormalSequence From tblServiceRequestStatus where SrStatusDescription = 'Pending DR Confirmation' and PartIDF is null
Select * From tblServiceRequestStatus where SrStatusDescription = 'Pending DR Confirmation'


Select * from tblPart where PartID = 259215


select TaskID,SrStatusDescription,sequence a,servicerequeststatusidf StatuIDF, WorkcenterIDF WC, IsBillable B, IsTerminal T,Indate, CompletedDate, CancelledByPersonIDF, CancelledDate,  QAViolationReported, QAViolationReportedByPersonIDF,  *
from tbltask 
	inner join tblServiceRequestStatus on servicerequeststatusidf = servicerequeststatusid
where ServiceRequestIDF  in (724795)
--AND IsBillable<>1 AND IsTerminal <>1
order by a



Select TaskID, SrStat.WorkcenterIDF, Indate, CompletedDate
, RANK() over(partition by ServiceRequestIDF order by t.Sequence) Sequence1
	, case when Sr.ServiceRequestStatusIDF  = t.ServiceRequestStatusIDF then 1 else 0 End CurrentStatus

From tbltask t
	inner join tblServiceRequestStatus SrStat on t.ServiceRequestStatusIDF = SrStat.ServiceRequestStatusID
	inner join tblServiceRequest Sr on Sr.ServiceRequestID = t.ServiceRequestIDF 
where t.InDate is not null
and t.ServiceRequestIDF = 724795

Select distinct ServiceRequestID
INTO #Billed
from tblInvoiceLineItem inner join tblServiceRequest on ServiceRequestID = ServiceRequestIDF where BundleIDF is not null

504289

Select * from tblServiceRequest where ServiceRequestID = 504288
Select * from tblServiceRequest where BundleIDF = 12618

*/
