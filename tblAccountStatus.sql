USE Vault
GO

Create table DocumentStatusHistory
(
	DocumentStatusHistoryID INT not null identity(1,1)
	,DocumentIDF int NOT NULL 
	,DateChanged datetime not null CONSTRAINT DF_DocumentStatusHistory_DateChanged DEFAULT (getdate())
	,NewDocumentStatusIDF tinyint
	,SignInIDF INT
)
ALTER TABLE [dbo].[DocumentStatusHistory] ADD  CONSTRAINT [pk_DocumentStatusHistory] PRIMARY KEY CLUSTERED 
(
	[DocumentIDF] ASC,
	[DateChanged] DESC,
	[DocumentStatusHistoryID] ASC
)
GO



CREATE TABLE dbo.AccountStatus
(
	AccountStatusID int NOT NULL CONSTRAINT PK_AccountStatus PRIMARY KEY CLUSTERED IDENTITY(1,1)
	,AccountStatusName varchar(100) NOT NULL
	--CONSTRAINT DF_AccountStatus_AccountStatusName  DEFAULT ('')  CONSTRAINT AK_AccountStatus_AccountStatusName UNIQUE NONCLUSTERED

	,SystemControlled bit NOT NULL CONSTRAINT DF_AccountStatus_SystemControlled  DEFAULT ((0))
	,Active bit NOT NULL CONSTRAINT DF_AccountStatus_Active  DEFAULT ((1))
	,CreatedByPersonIDF INT
	,LastUpdatedByPersonIDF INT
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_AccountStatus_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,AccountStatusTS timestamp NOT NULL
);

CREATE TABLE dbo.Taxonomy
(
	TaxonomyID int IDENTITY(1,1) NOT NULL CONSTRAINT PK_Taxonomy PRIMARY KEY CLUSTERED
	,TaxonomyName varchar(35) NOT NULL CONSTRAINT DF_Taxonomy_TaxonomyName  DEFAULT ('')
		CONSTRAINT AK_Taxonomy_TaxonomyName UNIQUE NONCLUSTERED 
	,SystemControlled bit NOT NULL CONSTRAINT DF_Taxonomy_SystemControlled  DEFAULT ((0))
	,Active bit NOT NULL CONSTRAINT DF_Taxonomy_Active  DEFAULT ((1))
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_Taxonomy_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,TaxonomyTS timestamp NOT NULL
);

set identity_insert Taxonomy on;


INSERT INTO dbo.Taxonomy(TaxonomyID,TaxonomyName,SystemControlled,Active)
SELECT TaxonomyID, TaxonomyName, 1 SystemControlled, 1 Active
FROM
(
	SELECT 1 TaxonomyID,'NearBy' TaxonomyName UNION ALL
	SELECT 2,'NearNet' UNION ALL
	SELECT 3,'On-Net' UNION ALL 
	SELECT 4,'Reported'
) A;

set identity_insert Taxonomy off;

CREATE TABLE dbo.tblAccountStatus
(
	AccountStatusID int NOT NULL CONSTRAINT PK_tblAccountStatus PRIMARY KEY CLUSTERED
	,AccountStatusName varchar(100) NOT NULL
	,SystemControlled bit NOT NULL CONSTRAINT DF_tblAccountStatus_SystemControlled  DEFAULT ((0))
	,Active bit NOT NULL CONSTRAINT DF_tblAccountStatus_Active  DEFAULT ((1))
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_tblAccountStatus_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,AccountStatusTS timestamp NOT NULL
);

ALTER TABLE dbo.tblAccountStatus  WITH CHECK ADD  CONSTRAINT CK_tblAccountStatus_AccountStatusName CHECK  ((len(ltrim(rtrim(AccountStatusName)))>(0)));

ALTER TABLE dbo.tblAccountStatus CHECK CONSTRAINT CK_tblAccountStatus_AccountStatusName;

INSERT INTO dbo.tblAccountStatus(AccountStatusID,AccountStatusName,SystemControlled,Active)
SELECT AccountStatusID, AccountStatusName, 1 SystemControlled, 1 Active
FROM
(
	SELECT 1 AccountStatusID,'Prospect'  AccountStatusName UNION ALL
	SELECT 2,'Current' UNION ALL
	SELECT 3,'Lost'
) A;

CREATE TABLE dbo.EntityEventDetail
(
	EntityEventDetailID int NOT NULL CONSTRAINT PK_EntityEventDetail PRIMARY KEY NONCLUSTERED IDENTITY(1,1)
	,EntityIDF TINYINT NOT NULL CONSTRAINT FK_EntityEventDetail_Entity FOREIGN KEY REFERENCES dbo.usysEntity (EntityID)
	,EventIDF TINYINT NOT NULL CONSTRAINT FK_EntityEventDetail_Event FOREIGN KEY REFERENCES dbo.usysEvent (EventID)
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_EntityEventDetail_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,EntityEventDetailTS timestamp NOT NULL
);
ALTER TABLE dbo.EventEntityDetail ADD CONSTRAINT IX_EventEntityDetail UNIQUE CLUSTERED 
(
	EventIDF ASC,
	EntityIDF ASC
);

CREATE TABLE dbo.ProductVehicleTypeDetail
(
	ProductVehicleTypeDetailID int NOT NULL CONSTRAINT PK_ProductVehicleTypeDetail PRIMARY KEY NONCLUSTERED IDENTITY(1,1)
	,ProductIDF INT NOT NULL CONSTRAINT FK_ProductVehicleTypeDetail_Product FOREIGN KEY REFERENCES dbo.Product (ProductID)
	,VehicleTypeIDF INT NOT NULL CONSTRAINT FK_ProductVehicleTypeDetail_VehicleType FOREIGN KEY REFERENCES dbo.VehicleType (VehicleTypeID)
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_ProductVehicleTypeDetail_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,ProductVehicleTypeDetailTS timestamp NOT NULL
);
ALTER TABLE dbo.VehicleTypeProductDetail ADD CONSTRAINT IX_VehicleTypeProductDetail UNIQUE CLUSTERED 
(
	VehicleTypeIDF ASC,
	ProductIDF ASC
);



CREATE TABLE dbo.tblCaseCompanyDetail
(
	CaseCompanyDetailID int NOT NULL CONSTRAINT PK_tblCaseCompanyDetail PRIMARY KEY NONCLUSTERED 
	,CaseIDF int NOT NULL CONSTRAINT FK_tblCaseCompanyDetail_tblCase FOREIGN KEY REFERENCES dbo.tblCase (CaseID)
	,CompanyIDF int NOT NULL CONSTRAINT FK_tblCaseCompanyDetail_tblCompany FOREIGN KEY REFERENCES dbo.tblCompany (CompanyID)
	,SignInIDF int NULL
	,DateCreated smalldatetime NOT NULL CONSTRAINT DF_tblCaseCompanyDetail_DateCreated  DEFAULT (getdate())
	,LastUpdated smalldatetime NULL
	,CaseCompanyDetailTS timestamp NOT NULL
)

ALTER TABLE dbo.tblCaseCompanyDetail ADD CONSTRAINT IX_tblCaseCompanyDetail UNIQUE CLUSTERED 
(
	CaseIDF ASC,
	CompanyIDF ASC
);


CREATE NONCLUSTERED INDEX IX_tblCaseCompanyDetail ON dbo.tblCaseCompanyDetail
(
	CaseIDF ASC,
	CompanyIDF ASC
);

CREATE TABLE dbo.usysInvoiceType
(
	InvoiceTypeID tinyint NOT NULL CONSTRAINT PK_usysInvoiceType PRIMARY KEY CLUSTERED --IDENTITY(1,1)
	,InvoiceTypeName varchar(35) NOT NULL CONSTRAINT DF_usysInvoiceType_InvoiceTypeName DEFAULT ('')
		CONSTRAINT AK_usysInvoiceType_InvoiceTypeName unique
);

INSERT INTO usysInvoiceType(InvoiceTypeID, InvoiceTypeName)
SELECT InvoiceTypeID, InvoiceTypeName
FROM
(
	SELECT 1 InvoiceTypeID, 'Normal' InvoiceTypeName UNION ALL
	SELECT 2, 'Sub' UNION ALL
	SELECT 3, 'Main' UNION ALL
	SELECT 4, 'Manual'
)A;

ALTER TABLE AccessType
ADD CONSTRAINT CK_AccessType CHECK (cast(IsCBL as int) + cast(IsDSL as int) <= 1 );


--Vault_dbo_109_80_12Dec2016.sql SPR

--affintus2.dbo.spJobPopulateMissingMatchScore
--affintus2.dbo.spJobPopulateAssessmentJFBlank