use newton
go
Select DeliverableName, deliverableIDF, WorkEventID, JournalID, WorkEventID+ JournalID
from
(
	Select deliverableIDF, sum(WorkEventID) WorkEventID
	from tblTask t
		outer apply
		(
			Select count(WorkEventID) WorkEventID
			from tblWorkEvent we
			where t.taskid = we.taskidf
		) w
	Group by deliverableIDF
)a
outer apply
(
	Select count(JournalID) JournalID
	from tblJournal j
	where j.deliverableIDF = a.deliverableIDF
) j
left outer join tblDeliverable d
	on a.deliverableIDF = d.DeliverableID
order by 5 desc
--Select * from tblDeliverable where deliverableid = 14399