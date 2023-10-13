use [dummy]
go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ArticleStatus]') AND type in (N'U'))
DROP TABLE [dbo].[ArticleStatus]
go

Create Table [dbo].[ArticleStatus]
(
	ArticleStatusID		Int Primary Key
	, ArticleStatus		varchar(50)
)
go
Delete from [ArticleStatus]
go
insert into [dbo].[ArticleStatus] (ArticleStatusID, ArticleStatus) values (1, 'Draft')
insert into [dbo].[ArticleStatus] (ArticleStatusID, ArticleStatus) values (2, 'Published')
insert into [dbo].[ArticleStatus] (ArticleStatusID, ArticleStatus) values (3, 'Retired')

go

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tblSignIn]') AND type in (N'U'))
DROP TABLE [dbo].[Article]
go

Create Table [dbo].[Article]
(
	ArticleID		Int Primary Key
	, Headline		varchar(250)
	, Body			text
	, Priority		int
	, StartDate		datetime
	, EndDate		datetime
	, ArticleStatusIDF		int foreign Key references  ArticleStatus(ArticleStatusID)
)

go
