use uscc
--Select *  from email.tblemailtemplate
/*
	Purpose			: 	get list of emails who is getting particular email template
	Author			: 	Kalpesh
	DateCreated		:	20110128
	DeliverableID	:	no dlv :(
*/
;with cte as 
(
Select FriendlyName, EmailAddress
from email.tblemaildetail emaildetail
inner join email.tblemailtemplate emailtemplate
	on emaildetail.foreignkeyid = emailtemplate.emailtemplateid
where foreigntablename = 'tblemailtemplate'
and emailrelationshipidf <>2
--order by ForeignKeyID
)
--select * from cte

SELECT FriendlyName Template,
	STUFF((
		SELECT ',' + t.EmailAddress
		FROM cte t
		WHERE t.FriendlyName = t1.FriendlyName
		ORDER BY t.EmailAddress
		FOR XML PATH('')
	),1,1,'') AS recipients
FROM cte t1
GROUP BY FriendlyName
--Select * from email.usysemailrelationship