SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spNewSubTest]
	(@Station_Name_1 	[char](20),
	@SubTest_Name_2 	[char](20),
	@SAP_Model_Name_3 	[char](20) = NULL,
	@Limit_Type_4 	[char](1),
	@UL_5 	[float] = NULL,
	@LL_6 	[float] = NULL,
	@strLimit_7 	[char](20) = NULL,
	@flgLimit_8 	[char](1) = NULL,
	@Units_9 	[char](10) = NULL,
	@Description_10 	[char](50) = NULL,
	@Author_11 	[char](25),
	@ACSEEMode_12 	[int],
	@SPCParm_13 	[char](1) = NULL,
	@Hard_UL_14 	[float] = NULL,
	@Hard_LL_15 	[float] = NULL,
	@ProductGroup_Mask_16 	[int] = NULL,
	@TransReply	[varchar](50)	OUTPUT)

/*
** PRODUCTION DATE:
**
** CREATION DATE:9/22/2001
** AUTHOR: Joel Smith
** PURPOSE: Add a new subtest to a station
**
** MODIFICATION HISTORY
**
*/

AS

DECLARE @ProbLevel	[int]
SET @ProbLevel = 0

BEGIN TRANSACTION

--insert into log table
	INSERT INTO SubTestLimitsLog
		(Station_Name,
		SubTest_Name,
		SAP_Model_Name,
		Limit_Type,
		UL,
		LL,
		strLimit,
		flgLimit,
		Units,
		Description,
		Author,
		ACSEEMode,
		SPCParm,
		Hard_UL,
		Hard_LL,
		Limit_Date,
		ProductGroup_Mask)		 
	VALUES 
		(@Station_Name_1,
		@SubTest_Name_2,
		@SAP_Model_Name_3,
		@Limit_Type_4,
		@UL_5,
		@LL_6,
		@strLimit_7,
		@flgLimit_8,
		@Units_9,
		@Description_10,
		@Author_11,
		@ACSEEMode_12,
		@SPCParm_13,
		@Hard_UL_14,
		@Hard_LL_15,
	 	getdate(),
	 	@ProductGroup_Mask_16)

SET @ProbLevel = @@ERROR

--insert into primary table
	INSERT INTO SubTestLimits 
		(Station_Name,
		SubTest_Name,
		SAP_Model_Name,
		Limit_Type,
		UL,
		LL,
		strLimit,
		flgLimit,
		Units,
		Description,
		Author,
		ACSEEMode,
		SPCParm,
		Hard_UL,
		Hard_LL,
		Limit_Date,
		ProductGroup_Mask)
		 
	VALUES 
		(@Station_Name_1,
		@SubTest_Name_2,
		@SAP_Model_Name_3,
		@Limit_Type_4,
		@UL_5,
		@LL_6,
		@strLimit_7,
		@flgLimit_8,
		@Units_9,
		@Description_10,
		@Author_11,
		@ACSEEMode_12,
		@SPCParm_13,
		@Hard_UL_14,
		@Hard_LL_15,
	 	getdate(),
	 	@ProductGroup_Mask_16)

SET @ProbLevel = @ProbLevel + @@ERROR

IF @ProbLevel != 0
    BEGIN
	ROLLBACK TRANSACTION
	SET @TransReply = 'ABORT - Create Subtest Failed'
    END
ELSE
    BEGIN
	COMMIT TRANSACTION
	SET @TransReply = 'Subtest Created'	
    END

GO