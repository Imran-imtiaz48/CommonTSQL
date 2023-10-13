use Newton
go
update a
--select DeliverableId, CycleIDF, DeliverableName, ApplicationIDF
set CycleIDF= 1589, ApplicationIDF=134
from tblDeliverable a
where DeliverableID in(58353, 58352, 58351, 58350)


use Newton
go
--update a
select DeliverableId, CycleIDF, DeliverableName, ApplicationIDF
--set CycleIDF= 1589, ApplicationIDF=134
from tblDeliverable a
where DeliverableID in(58562 , 58608)

use Newton
go
update a
--select DeliverableId, CycleIDF, DeliverableName, ApplicationIDF, DeliverableName
set CycleIDF= 1594, ApplicationIDF=130
from tblDeliverable a
where DeliverableID = 58562 --in(58562 , 58608)