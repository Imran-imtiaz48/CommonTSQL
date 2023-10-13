Use Vault
go
Select Sequence, InDate, CompletedDate, CompletedByPersonIDF, ServiceRequestStatusIDF, ServiceRequestIDF 
from tblTask
Where ServiceRequestIDF = 290333
Order by Sequence
Select ServiceRequestStatusIDF, WorkCenterIDF, PartIDF, OrderIDF, SalesOrderIDF
from tblServiceRequest Where ServiceRequestID = 290333

--Select * from tblServiceRequestStatus where ServiceRequestStatusID = 48687
Select * from tblServiceRequestStatus where PartIDF = 286390 and OrderTypeIDF = 5 