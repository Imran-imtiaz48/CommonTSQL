USE [IRG]
go

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[trPriceSchedule_insert]'))
DROP TRIGGER [dbo].[trPriceSchedule_insert]
GO

CREATE TRIGGER [trPriceSchedule_insert]
ON [dbo].[tblPriceSchedule]  
AFTER INSERT 
AS 

/*
Purpose			: Insert all record from tblPart into  tblProductPrice on insert of tblPriceSchedule
Date Created	: 20090626
Author			: Kalpesh
Version			: 96.00

Ref. 			: 
Para. 			: 

PARAMETER NOTES:
*/


BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- INTerfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @PriceScheduleID INT
	DECLARE @lProductPriceID INT

	SET @PriceScheduleID = 0
	SET @lProductPriceID = 0 
	SELECT @PriceScheduleID = PriceScheduleID  FROM inserted    

DECLARE @tblProductPrice TABLE 
	(
		ProductPriceID		INT,
		PartIDF				INT,
		PriceScheduleIDF	INT,
		SchedulePrice		DECIMAL(9,2)
	)

	SELECT @lProductPriceID = ISNULL(MAX(ProductPriceID), 0) FROM tblProductPrice

	INSERT INTO @tblProductPrice
	(
		ProductPriceID, 
		PartIDF, 
		PriceScheduleIDF, 
		SchedulePrice
	)
	SELECT 
		ROW_NUMBER() OVER (ORDER BY PartID DESC) + @lProductPriceID, 
		tblPart.PartID, 
		@PriceScheduleID,
		SchedulePriceRecord.SchedulePrice
	FROM tblPart
	CROSS APPLY (SELECT TOP 1 SchedulePrice FROM dbo.fncProductPriceForPriceShcedule(tblPart.PartID, @PriceScheduleID) ) SchedulePriceRecord


	/*UPDATE @tblProductPrice 
		SET SchedulePrice = (SELECT SchedulePrice FROM dbo.fncProductPriceForPriceShcedule(@tblProductPrice.PartID , @tblProductPrice.PriceScheduleID))*/

	INSERT INTO tblProductPrice
		(
		ProductPriceID,
		PartIDF,
		PriceScheduleIDF,
		SchedulePrice
		)
	SELECT 
		ProductPriceID,
		PartIDF,
		PriceScheduleIDF,
		SchedulePrice 
	FROM @tblProductPrice

	UPDATE dbo.dboidProvider 
		SET max_id =(SELECT ISNULL(MAX(ProductPriceID),0) FROM tblProductPrice)
	WHERE schema_table like 'dbo_ProductPrice'


END
GO
/*
INSERT INTO tblPriceSchedule(PriceScheduleID, PriceScheduleName, PriceScheduleStatusIDF, EffectiveDate, DiscountStructureIDF,  SignInIDF, ApprovedByPersonIDF)
VALUES (1,1,1,null,1,null,null)


INSERT INTO tblPriceSchedule(PriceScheduleID, PriceScheduleName, PriceScheduleStatusIDF, EffectiveDate, DiscountStructureIDF,  SignInIDF, ApprovedByPersonIDF)
SELECT MAX(PriceScheduleID) + 1, 1,1,null,1,null,null FROM tblPriceSchedule
--VALUES (1,1,1,null,1,null,null)
SELECT * FROM tblProductPrice
*/

go





USE master
GO