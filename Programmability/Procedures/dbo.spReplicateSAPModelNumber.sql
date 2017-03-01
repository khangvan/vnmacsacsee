SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spReplicateSAPModelNumber]
	(@SAP_Model_Name_1 	[char](20) = NULL,
	@SAP_Model_New_2 	[char](20) = NULL,
	@Author_3 [char](25),
	@TransReply	[varchar](100)	OUTPUT)

/*
** PRODUCTION DATE:
**
** CREATION DATE:10/4/2001
** AUTHOR: Joel Smith
** PURPOSE:Replicate an existing SAP Model Number to a new #
**
** MODIFICATION HISTORY
**
*/

AS

--pre transaction checks
		IF @SAP_Model_Name_1 IS NULL
			BEGIN
				SET @TransReply = 'ABORT - A Template Model # Is Required'
				RETURN
			END

		IF @SAP_Model_New_2 IS NULL
			BEGIN
				SET @TransReply = 'ABORT - A New Model # Is Required'
				RETURN
			END

		IF NOT EXISTS (SELECT SAP_Model_Name FROM SubTestLimits WHERE SAP_Model_Name = @SAP_Model_Name_1)
			BEGIN
				SET @TransReply = 'ABORT - Template Model Number (' + RTrim(@SAP_Model_Name_1) + ') Does Not Exist'
				RETURN
			END

		IF EXISTS (SELECT SAP_Model_Name FROM SubTestLimits WHERE SAP_Model_Name = @SAP_Model_New_2)
			BEGIN
				SET @TransReply = 'ABORT - New Model Number (' + RTrim(@SAP_Model_New_2) + ') Already Exists'
				RETURN
			END
--end checks
	
DECLARE @ProbLevel	[int]
SET @ProbLevel = 0

BEGIN TRANSACTION

--insert into temp table
	SELECT Station_Name,
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
		ProductGroup_Mask
	INTO #SAPRepTemp
	FROM SubTestLimits
	WHERE SAP_Model_Name = @SAP_Model_Name_1

SET @ProbLevel = @ProbLevel + @@ERROR

	UPDATE #SAPRepTemp
		SET SAP_Model_Name = @SAP_Model_New_2,
			Author = @Author_3,
			Limit_Date = getdate()

SET @ProbLevel = @ProbLevel + @@ERROR

--copy new records to log file
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
		
		SELECT Station_Name,
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
			ProductGroup_Mask			
		FROM #SAPRepTemp

SET @ProbLevel = @ProbLevel + @@ERROR

--copy new records to limits file
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
		
		SELECT Station_Name,
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
			ProductGroup_Mask			
		FROM #SAPRepTemp

SET @ProbLevel = @ProbLevel + @@ERROR

--check for problems, commit or rollback
IF @ProbLevel != 0
    BEGIN
	ROLLBACK TRANSACTION
	DROP TABLE #SAPRepTemp
	SET @TransReply = 'ABORT - Replication Failed, (' + @ProbLevel + ') Errors'
    END
ELSE
    BEGIN
	COMMIT TRANSACTION
	DROP TABLE #SAPRepTemp
	SET @TransReply = '(' + RTrim(@SAP_Model_Name_1) + ') Attributes Replicated to New Model Number (' + RTrim(@SAP_Model_New_2) + ')'
    END












GO