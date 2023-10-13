use newton
go
Select DeliverableID, Name
from vDeliverable
where Note collate SQL_Latin1_General_CP1_CS_AS LIKE '%<[A,p]%