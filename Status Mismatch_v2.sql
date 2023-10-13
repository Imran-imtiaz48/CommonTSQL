use Vault
go
Declare @ServiceRequestID as int
--set @ServiceRequestID = 366653
/********************************************************************
--FIND THE SR WHOSE STATUS IS NOT AS PER CALCULATION(I.E. AS FROM TBLTASK)
*******************************************************************/
--Ref scripts
--Vault_Support_81_14_28110_update_sr_status.sql
--Vault_Support_78_64_27702_Mismatched_SR_Status_Workcenters_still_an_issue.sql
/********************************************************************/
--Populate all SR
Select ServiceRequestID, ServiceRequestStatusIDF, null CServiceRequestStatusIDF into tmpCalculatedSRStatus
from tblServiceRequest 
where @ServiceRequestID is null OR ServiceRequestID = @ServiceRequestID
/********************************************************************/
--If Seq = 99 and completed Date is not null set status to Cancelled
update a
set a.cServiceRequestStatusIDF = b.ServiceRequestStatusIDF
from tmpCalculatedSRStatus a
	inner join 
		(
			Select ServiceRequestIDF, ServiceRequestStatusIDF, RANK() Over(Partition by ServiceRequestIDF Order by Sequence desc) rnk
			from tblTask 
			where Sequence >= 90
			AND CompletedDate is not null
			AND CancelledDate is null
			and (@ServiceRequestID is null or ServiceRequestIDF = @ServiceRequestID)
		) b
		on a.ServiceRequestID = b.ServiceRequestIDF
		and b.rnk = 1

/********************************************************************/
--SR in initial status
UPDATE a
set a.cServiceRequestStatusIDF = b.ServiceRequestStatusIDF
from tmpCalculatedSRStatus a
inner join
	(
		Select ServiceRequestIDF, ServiceRequestStatusIDF, Sequence, RANK() Over(Partition by ServiceRequestIDF Order by Sequence) rnk
		From  tblTask
		where ServiceRequestIDF in 
		(--get the list of SR in initial status
			Select ServiceRequestIDF
			from
			(
				Select Task.ServiceRequestIDF , count(*) TaskCount, CompletedTask.TaskCount CompletedTaskCount
				from tblTask Task
				inner join
				(
					Select iTask.ServiceRequestIDF , count(*) TaskCount
					from tblTask iTask
					where iTask.CompletedDate is null
					and iTask.CancelledDate is null
					and (@ServiceRequestID is null or iTask.ServiceRequestIDF = @ServiceRequestID)
					group by iTask.ServiceRequestIDF
				) CompletedTask
					on Task.ServiceRequestIDF = CompletedTask.ServiceRequestIDF

					and (@ServiceRequestID is null or task.ServiceRequestIDF = @ServiceRequestID)
					and Task.CancelledDate is null
				group by Task.ServiceRequestIDF, CompletedTask.TaskCount
			)a
			
			where TaskCount = CompletedTaskCount
			and tblTask.CancelledDate is null
		)
	) b
	on a.ServiceRequestID = b.ServiceRequestIDF
	and b.rnk = 1



/********************************************************************/
--Update rest of the SR(Get all completed SR and find minimum Seq task of the non-completed Task)
/********************************************************************/


--Get list of completed Task
Select TaskID, ServiceRequestIDF, Sequence, ServiceRequestStatusIDF into tmpCompleteTask from tblTask
WHERE CancelledDate IS NULL
	AND QAViolationReported IS NULL
	AND CompletedDate IS NOT NULL
	and CancelledDate is null
	--Ignore SR in Cancelled Status
	AND ServiceRequestIDF in (Select ServiceRequestID from tmpCalculatedSRStatus WHERE CServiceRequestStatusIDF is null)
	and (@ServiceRequestID is null or ServiceRequestIDF = @ServiceRequestID)

--Get list of non-completed Task
Select distinct a.TaskID, a.ServiceRequestIDF, a.Sequence, a.ServiceRequestStatusIDF, c.IsException into tmpInCompleteTask
from tblTask a	
	inner join tblServiceRequestStatus c
		on a.ServiceRequestStatusIDF = c.ServiceRequestStatusID
	inner join tmpCompleteTask b
		on a.ServiceRequestIDF = b.ServiceRequestIDF
		and a.TaskID not in (Select TaskID from tmpCompleteTask)
inner join (Select ServiceRequestIDF, max(Sequence) Sequence from tmpCompleteTask group by ServiceRequestIDF) b1
		on a.ServiceRequestIDF = b1.ServiceRequestIDF
		and  cast(a.Sequence as decimal(7,2)) >= cast(b1.Sequence as decimal(7,2))
where a.QAViolationReported is null 
	and a.CancelledDate is null
	and a.CompletedDate is null
	and (@ServiceRequestID is null or a.ServiceRequestIDF = @ServiceRequestID)


--update with min status
update a
set a.cServiceRequestStatusIDF = b.ServiceRequestStatusIDF
from tmpCalculatedSRStatus a
	inner join
	(
		Select ServiceRequestIDF, Sequence, ServiceRequestStatusIDF
		, RANK() Over(Partition by ServiceRequestIDF Order by Sequence,IsException desc) rnk
		from tmpInCompleteTask task
	) b
		on a.ServiceRequestID = b.ServiceRequestIDF 
		and b.rnk = 1
where a.cServiceRequestStatusIDF is null


/********************************************************************/
--FIND MISMATCH
Select sr.ServiceRequestID
	, sr.ServiceRequestStatusIDF, oServiceRequestStatus.PartIDF, oServiceRequestStatus.SubClassIDF, oServiceRequestStatus.servicerequeststatusName
	, sr.cServiceRequestStatusIDF CalcServiceRequestStatusIDF, cServiceRequestStatus.PartIDF, CServiceRequestStatus.SubClassIDF, cServiceRequestStatus.servicerequeststatusName
	
from tmpCalculatedSRStatus Sr
	left outer join tblServiceRequestStatus oServiceRequestStatus
		on sr.ServiceRequestStatusIDF = oServiceRequestStatus.ServiceRequestStatusID
	left outer join tblServiceRequestStatus cServiceRequestStatus
		on sr.cServiceRequestStatusIDF = cServiceRequestStatus.ServiceRequestStatusID
where sr.ServiceRequestStatusIDF <> sr.cServiceRequestStatusIDF
--and oServiceRequestStatus.servicerequeststatusName not in ('Cancelled','CPE Add Comp','Pending Replacement','Replaced - Rdy. To Disco')

--AND LOA = 1
/********************************************************************/
--Select count(*) from tmpCalculatedSRStatus where cServiceRequestStatusIDF  is null
--Select * from tmpCalculatedSRStatus where cServiceRequestStatusIDF  is null
--Select * from tmpInCompleteTask where ServiceRequestIDF = 27146
--Select * from tmpCompleteTask where ServiceRequestIDF = 27146

--Select * from tmpCompleteTask
--Select * from tmpInCompleteTask
--Select * from tmpCalculatedSRStatus


drop table tmpCompleteTask
drop table tmpInCompleteTask
drop table tmpCalculatedSRStatus
