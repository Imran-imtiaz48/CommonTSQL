use TruView
go
/*
tblEmail -- tblEmailDetail
tblAuditLog
tblBankCardTransLog
tblJournal
tblInvoiceDailyFiles
*/
--Delete From answers where year(answer_date)<>2015
--Select count(*) From answers where year(answer_date)=2015
declare @space TABLE (
tableName sysname,
 numrows integer,
 reserved varchar(25),
 data varchar(25),
 indexsize varchar(25),
 unused varchar(25))

declare objcurs cursor for 
--select [name] from sys.objects where type = 'U'
select TABLE_SCHEMA+'.'+ TABLE_NAME from INFORMATION_SCHEMA.TABLES  where TABLE_TYPE = 'base table'

declare @name sysname
open objcurs
fetch next from objcurs into @name
while @@fetch_status = 0
begin
 insert into @space
 exec sp_spaceused @name
 fetch next from objcurs into @name
end
close objcurs
deallocate objcurs

select cast(replace(data,'KB','') as INT)/1024.0 + Cast(replace(reserved,'KB','') as int)/1024.0,* from @space order by 
convert(integer, replace(data,'KB','')) desc


--SELECT 
-- t.NAME AS TableName,
-- i.name AS indexName,
-- SUM(p.rows) AS RowCounts,
-- SUM(a.total_pages) AS TotalPages, 
-- SUM(a.used_pages) AS UsedPages, 
-- SUM(a.data_pages) AS DataPages,
-- (SUM(a.total_pages) * 8) / 1024 AS TotalSpaceMB, 
-- (SUM(a.used_pages) * 8) / 1024 AS UsedSpaceMB, 
-- (SUM(a.data_pages) * 8) / 1024 AS DataSpaceMB
--FROM 
-- sys.tables t
--INNER JOIN  
-- sys.indexes i ON t.OBJECT_ID = i.object_id
--INNER JOIN 
-- sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
--INNER JOIN 
-- sys.allocation_units a ON p.partition_id = a.container_id
--WHERE 
-- t.NAME NOT LIKE 'dt%' AND
-- i.OBJECT_ID > 255 AND  
-- i.index_id <= 1
-- and t.NAME = 'Task'
--GROUP BY 
-- t.NAME, i.object_id, i.index_id, i.name 
--ORDER BY 
-- OBJECT_NAME(i.object_id) 
 
 
 --drop table tmpInCompleteTask
--drop table @space
/*
truncate table tblAuditLog
truncate table trans.tblBankCardTransLog
drop table BU27636
drop table tblProspectImport_04132011
drop table tblProspectImport_04262011_1
drop table tblProspectImport_04262011_2
drop table tblProspectImport_dlv25288__20120329
drop table tblProspectImport_dlv30618_13Mar2013

drop table tblProspectImport_dlv32158_07Jun2013
drop table tblProspectImport_20120130
drop table tblProspectImport_dlv26533__20120605
drop table tblProspectImport_dlv30152_05Mar2013
*/
--Select top 10 * from email.tblEmail
--update email.tblEmail set body = ''
--2454984 	tblEmail	223364	2456408 KB	2454984 KB	608 KB	816 KB

/*
sp_helpdb usr2
--USR2	   6007.81 MB
alter database usr2 set recovery simple

dbcc shrinkdatabase(usr2, 10)
drop table tmpCalculatedSRStatus
*/

--update tblDocument set DocumentData = ''
--UPDATE tblDocument SET DocumentData = CAST('0x78DA2BCB2C4A4C07000676021A' AS VARBINARY(MAX)) 

--select * from tblDocument

--alter table tblDocument
--drop column DocumentData
--go
--alter table tblDocument
--add DocumentData image
--DBCC CLEANTABLE (Vault,'dbo.tblDocument', 0)  

--DBCC shrinkdatabase(vault, 10)

--sp_helpdb vault

--alter database Vault set recovery simple

--SELECT
--        alloc_unit_type_desc
--       ,page_count
--       ,avg_page_space_used_in_percent
--       ,record_count
--FROM
--        sys.dm_db_index_physical_stats(
--             DB_ID()
--            ,OBJECT_ID(N'dbo.tblDocument')
--            ,NULL
--            ,NULL,'Detailed') ;



/*
https://social.msdn.microsoft.com/Forums/sqlserver/en-US/00e9e4e0-a276-4781-a5c7-94eac0391368/reclaiming-reserved-space-for-tables?forum=sqldatabaseengine

-- Clears Unused space of CLUSTERED indexes
EXEC sp_MSforeachtable @command1='print ''?'' DBCC DBREINDEX (''?'', '' '', 80)'
--Use this to get rid of unallocated space
--DBCC SHRINKDATABASE (DB,10)"

exec sp_spaceused tblZipCodeRadiusDetail

*/
--ALTER AUTHORIZATION ON DATABASE::VaultPrequal TO sa;

/*
SET ARITHABORT ON
SET ANSI_WARNINGS ON
*/


/*
use AffintusAlpha
go
truncate table tblCandidateResume

Select * from INFORMATION_SCHEMA.COLUMNS where column_name like '%Resume%' 
candidates
alter table candidates drop constraint  fk_candidates_tblCandidateResume
alter table matches drop constraint  FK_matches_tblCandidateResume
alter table tblCandidateResume drop constraint  FK__tblCandid__paren__5E80B329

backup database AffintusAlpha to disk = 'D:\Temp\AffintusAlpha Scrubed As Of May  4 2018 10 19AM' with stats = 1


*/


/*
USE [Vault2]
GO
--DBCC SHRINKFILE (N'Vault' , 12000)
GO
CREATE PROC [BU].[spSRCleanDataOnServiceRequestID]
(
	@ServiceRequestID ServiceRequestIDTableType READONLY
)
AS
BEGIN
	--select * from @SRs
DECLARE @Invoices TABLE(InvoiceID int)
	
Delete InvoiceAdjustment
	from tblInvoiceAdjustment InvoiceAdjustment
	inner join tblInvoiceLineItem InvoiceLineItem on InvoiceLineItem.InvoiceLineItemID = InvoiceAdjustment.DeletedInvoiceLineItemIDF 
	inner join tblinvoice Invoice on Invoice.invoiceid = InvoiceLineItem.InvoiceIDF
	where InvoiceLineItem.ServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )
	--where Invoice.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
		
Delete InvoiceAdjustment
	from tblInvoiceAdjustment InvoiceAdjustment
	inner join tblInvoiceLineItem InvoiceLineItem on InvoiceLineItem.InvoiceLineItemID = InvoiceAdjustment.AddedInvoiceLineItemIDF  
	inner join tblinvoice Invoice on Invoice.invoiceid = InvoiceLineItem.InvoiceIDF
	where InvoiceLineItem.ServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )
	--where Invoice.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

Delete InvoiceLineItem
	from tblInvoiceLineItem InvoiceLineItem
	Where --InvoiceLineItem.InvoiceIDF in (select InvoiceID from @Invoices)
	--and 
	InvoiceLineItem.ServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )
	--where Invoice.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE ServiceRequestStatusHistory
--Select * 
	from tblServiceRequestStatusHistory ServiceRequestStatusHistory
	inner join tblServiceRequest sr on sr.ServiceRequestID = ServiceRequestStatusHistory.ServiceRequestIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE TASK	
--Select * 
	from tblTask task 
		inner join tblServiceRequest sr on sr.ServiceRequestID = task.ServiceRequestIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount


DELETE CPEMaint
--Select * 
		from tblCPEMaintenanceSR CPEMaint
		inner join tblServiceRequest sr on sr.ServiceRequestID = CPEMaint.CPEMaintenanceSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
 

DELETE obj
From tblSrRelationship obj	
	where 
	obj.IsServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )
	OR
	obj.ForServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE obj
From tblVendorBillLineItem obj
	inner join tblAuditHistory AuditHistory  on obj.AuditHistoryIDF = AuditHistory.AuditHistoryID
	inner join tblServiceRequest sr on sr.ServiceRequestID = AuditHistory.ServiceRequestIDF
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE AuditHistory 
--Select * 
	from tblAuditHistory AuditHistory 
	inner join tblServiceRequest sr on sr.ServiceRequestID = AuditHistory.ServiceRequestIDF
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE SiteSurvey
--Select * 
	from tblSiteSurvey SiteSurvey
	inner join tblServiceRequest sr on sr.ServiceRequestID = SiteSurvey.SiteSurveyID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount


DELETE ad
--Select * 
	from tblProServiceSR ProSR
	inner join tblShipment Ship on ship.ShipmentID = ProSR.ProServiceSRID
	inner join tblServiceRequest sr on sr.ServiceRequestID = ProSR.ProServiceSRID 
	inner join tblAddress ad on ad.AddressID = ship.DestinationAddressIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount


DELETE ad
--Select * 
	from tblProServiceSR ProSR
	inner join tblShipment Ship on ship.ShipmentID = ProSR.ProServiceSRID
	inner join tblServiceRequest sr on sr.ServiceRequestID = ProSR.ProServiceSRID 
	inner join tblAddress ad on ad.AddressID = ship.OriginationAddressIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
 	 	
DELETE Ship
--Select * 
	from tblProServiceSR ProSR
	inner join tblShipment Ship on ship.ShipmentID = ProSR.ProServiceSRID
	inner join tblServiceRequest sr on sr.ServiceRequestID = ProSR.ProServiceSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE OT
--Select * 
	from tblProServiceSR ProSR
	inner join tblOverTimeRequest OT on OT.ProServiceSRIDF = ProSR.ProServiceSRID
	where ProSR.ProServiceSRID in (Select ServiceRequestID from @ServiceRequestID )
	

DELETE obj
from dbo.tblProserviceClosePaymentType obj
--Select * 
	inner join tblProServiceSR ProSR on obj.ProServiceSRIDF = ProSr.ProServiceSRID
	inner join tblServiceRequest sr on sr.ServiceRequestID = ProSR.ProServiceSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE ProSr
--Select * 
	from tblProServiceSR ProSR
	inner join tblServiceRequest sr on sr.ServiceRequestID = ProSR.ProServiceSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
 	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
 	
DELETE Interface
--Select * 
	from tblInterface Interface
	inner join tblCPESR obj on obj.CPESRID = Interface.CPESRIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	
DELETE Ad
--Select * 
	from tblCPESRInShipment CPEShip
	inner join tblCPESR obj on obj.CPESRID = CPEShip.CPESRIDF 
	inner join tblShipment ship on ship.ShipmentID = CPEShip.ShipmentIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	inner join tblAddress ad on ad.AddressID = ship.OriginationAddressIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	
	
DELETE Ad
--Select * 
	from tblCPESRInShipment CPEShip
	inner join tblCPESR obj on obj.CPESRID = CPEShip.CPESRIDF 
	inner join tblShipment ship on ship.ShipmentID = CPEShip.ShipmentIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	inner join tblAddress ad on ad.AddressID = ship.DestinationAddressIDF 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	
DELETE Ship
--Select * 
	from tblCPESRInShipment CPEShip
	inner join tblCPESR obj on obj.CPESRID = CPEShip.CPESRIDF 
	inner join tblShipment ship on ship.ShipmentID = CPEShip.ShipmentIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

DELETE CPEShip
--Select * 
	from tblCPESRInShipment CPEShip
	inner join tblCPESR obj on obj.CPESRID = CPEShip.CPESRIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount


DELETE CPESREnabledFeature
--Select * 
	from tblCPESREnabledFeature CPESREnabledFeature
	inner join tblCPESR obj on obj.CPESRID = CPESREnabledFeature.CPESRIDF 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj	
--Select * 
	from tblCPERentalSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPERentalSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblCPESR obj
	inner join tblCPERentalSR sr
			on sr.CPESRIDF = obj.CPESRID
	where obj.CPESRID in (Select ServiceRequestID from @ServiceRequestID )
			
DELETE obj
--Select * 
	from tblCPESR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount

Select CredentialID 
	into #buCredential
From (
Select Cred.CredentialID 
	from tblCredential Cred 
	inner join tblBroadband obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.BroadbandID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
Union All
Select Cred.CredentialID
	from tblCredential Cred 
	inner join tblDBUSR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.DBUSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
Union All
Select Cred.CredentialID 
	from tblCredential Cred 
	inner join tblEmailSR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.EmailSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
Union All
Select Cred.CredentialID
	from tblCredential Cred 
	inner join tblCPESR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	) as a

	Update obj
	set obj.CredentialIDF = null
	from tblCredential Cred 
	inner join tblBroadband obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.BroadbandID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

	Update obj
	set obj.CredentialIDF = null
	from tblCredential Cred 
	inner join tblDBUSR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.DBUSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

	Update obj
	set obj.CredentialIDF = null
	from tblCredential Cred 
	inner join tblEmailSR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.EmailSRID 
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

	Update obj
	set obj.CredentialIDF = null
	from tblCredential Cred 
	inner join tblCPESR obj on obj.CredentialIDF = Cred.CredentialID 
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPESRID  
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

	DELETE Cred
	From #buCredential upd
	inner join tblCredential Cred on Cred.CredentialID = upd.CredentialID

DELETE obj
--Select * 
	from tblWWANSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.WWANSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	
	
DELETE obj
--Select * 
	from tblWirelineSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.WirelineSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblWifiSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.WifiSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblCircuitTestHistory obj
	inner join tblBroadband bb on bb.BroadbandID = obj.BroadbandIDF
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.BroadbandIDF
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblBroadband obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.BroadbandID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj	
--Select * 
	from tblEmailSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.EmailSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblDBUSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.DBUSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )



DELETE obj
--Select * 
	from tblCPERentalSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.CPERentalSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE obj
--Select * 
	from tblMNSR obj
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = obj.MNSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )


DELETE MNSR		
--Select * 
	from tblManagedSR MNSR
	inner join tblServiceRequest sr
			on sr.ServiceRequestID = MNSR.ManagedSRID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )
	
DELETE SRPrice
--Select * 
	from tblSRPriceHistory SRPrice
		inner join tblServiceRequest sr
			on sr.ServiceRequestID = SRPrice.ServiceRequestIDF 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE PreSR
--Select * 
from tblPrerequisiteServiceRequest PreSR 
WHERE DependentServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )

DELETE PreSR
--Select * 
from tblPrerequisiteServiceRequest PreSR 
WHERE SupportingServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )

DELETE SRJrnl
	FROM tblServiceRequestJournal SRJrnl
	WHERE ServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )


DECLARE @PO TABLE(POLineItemID INT)

	INSERT INTO @PO(POLineItemID) 
	SELECT POLineItemIDF 	
	from tblServiceRequest sr
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE dsc
	from tblservicerequest sr
	inner join tbldisconnect dsc on dsc.disconnectid = sr.servicerequestid
	where sr.ServiceRequestId in (Select ServiceRequestID from @ServiceRequestID )

DELETE dsc
	from tblservicerequest sr
	inner join tbldisconnect dsc on dsc.CancelledServiceRequestIDF = sr.servicerequestid
	where sr.ServiceRequestId in (Select ServiceRequestID from @ServiceRequestID )
		
	Update sr
		set ReplacesServiceRequestIDF = null
	from tblservicerequest  sr
	where sr.ReplacesServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )

	--CancelledServiceRequestIDF

DELETE tblSPRHistory
	Where ServicerequestIDF in (Select ServiceRequestID from @ServiceRequestID)

update sr
set ChangedByServiceRequestIDF = null
----Select * 
	from tblServiceRequest sr
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

update sr
set ChangesServiceRequestIDF = null
----Select * 
	from tblServiceRequest sr
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ChangesServiceRequestIDF in (Select ServiceRequestID from @ServiceRequestID )

Delete SR
----Select * 
	from tblServiceRequest sr
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

DELETE PO
--Select * 
	from tblPOLineItem PO
	inner join tblServiceRequest sr on sr.POLineItemIDF = PO.POLineItemID 
	--where sr.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
	where PO.POLineItemID in (Select POLineItemID from @PO)
	
	--drop table @ServiceRequestID
	drop table #buCredential
--DELETE Ord	
------Select * 
--	from tblOrder ord 
--	inner join tblSalesOrder so on so.SalesOrderID = ord.SalesOrderIDF 
--	where so.AccountIDF = 1000000140
--	--where sr.ServiceRequestID in (Select ServiceRequestID from @ServiceRequestID )

--	Delete SO
--	--Select * 
--	from tblSalesOrder SO 
--	where so.AccountIDF = 1000000140
	--where SO.AccountIDF not in (1000000273, 1000000140, 1000000291) -- tblAccount
END

go


Select year(datecreated), count(*)
From tblServiceRequest
group by year(datecreated)

create table #Sr(SrID int, SrID2 int)

update sr
set sr.ChangesServiceRequestIDF = null
	 ,sr.ChangedByServiceRequestIDF = null
output deleted.ChangesServiceRequestIDF, deleted.ChangedByServiceRequestIDF  into  #Sr
From tblServiceRequest sr
where  year(datecreated) = 2014

update sr
set sr.ChangesServiceRequestIDF = null
	 ,sr.ChangedByServiceRequestIDF = null
	 --output deleted.ServiceRequestID  into  #Sr
From tblServiceRequest sr
where  ServiceRequestID IN (Select SrID From #Sr union Select SrID2 From #Sr)

	DECLARE @SRs ServiceRequestIDTableType

	Insert into @SRs(ServiceRequestID, ORderIDF, PartIDf, SalesOrdeRIDF, ServiceRequestCategoryIDF)
	Select ServiceRequestID, 0 ORderIDF,  0 PartIDf,  0 SalesOrdeRIDF,  0 ServiceRequestCategoryIDF
	FROM tblServiceRequest
	where year(datecreated) = 2014

	exec [BU].[spSRCleanDataOnServiceRequestID] @ServiceRequestID = @SRs
go
Select year(datecreated), count(*)
From tblServiceRequest
group by year(datecreated)

go
drop table #Sr
go
DROP PROC [BU].[spSRCleanDataOnServiceRequestID]
GO

*/