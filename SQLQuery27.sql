Select PrequalSite .*,  Address1
from tblPrequalSite PrequalSite 
inner join tblSite on SiteID = SiteIDF
inner join contact.tblAddress on AddressID = AddressIDF
where PrequalIDF = 6640