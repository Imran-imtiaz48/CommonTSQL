USE USCC
GO
SELECT b.UserName, c.Password
from aspnet_Users b	
	INNER JOIN aspnet_Membership c
		on b.UserID = c.UserID

--SELECT * from aspnet_Membership
--SELECT * from aspnet_Users