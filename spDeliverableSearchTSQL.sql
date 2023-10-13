SELECT Object_id
, DeliverableID, Project, Package
, ObjectStatus Status, D.Name DeliverableName
, case Difficulty when 'High' then Difficulty when 'Medium' then Difficulty when 'Low' then Difficulty else 'N/A' end Difficulty
, case Difficulty when 'High' then 1 when 'Medium' then 2 when 'Low' then 3 else 4 end DifficultySorter
, PriorityName, PriorityID, CreatedDate, ISNULL(cy.CycleName, '') CycleName, d.DeliverableTypeID, d.DeliverableTypeName
, ROUND(SUM(CAST(isnull(DATEDIFF(n, we.StartTime, we.EndTime),0) AS FLOAT)/60), 2) Hours
FROM dbo.vDeliverable D
LEFT OUTER JOIN vTask t
	ON d.DeliverableID = t.DeliverableIDF
LEFT OUTER JOIN vWorkEvent we
	ON t.TaskID = we.TaskIDF
LEFT OUTER JOIN 
	(
		SELECT Package_ID, CycleName
		FROM dbo.fncGetCycles()
	) cy
ON d.package_id= cy.package_id
WHERE Object_id in (21032, 20929)
group by 
Object_id, DeliverableID, Project, Package, ObjectStatus, D.Name, Difficulty, PriorityName, PriorityID, CreatedDate, isnull(cy.CycleName, ''), d.DeliverableTypeID, d.DeliverableTypeName