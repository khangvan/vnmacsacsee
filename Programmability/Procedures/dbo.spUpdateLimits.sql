SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spUpdateLimits]
	(@Station_Name_1 	[char](20) = NULL,
	 @SubTest_Name_2 	[char](20) = NULL,
	 @UL_3 	[float] = NULL,
	 @LL_4 	[float] = NULL,
	 @strLimit_5 	[char](20) = NULL,
	 @flgLimit_6 	[char](1) = NULL,
	 @Units_7 	[char](10) = NULL,
	 @Description_8 	[char](50) = NULL,
	 @Author_9 	[char](25) = NULL,
	 @ACSEEMode_10 	[int] = NULL,
	 @SPCParm_11 	[char](1) = NULL,
	 @Hard_UL_12 	[float] = NULL,
	 @Hard_LL_13 	[float] = NULL,
	 @SAP_Model_Name_14	[char](20) = NULL,
	 @TransReply	[varchar](150)	OUTPUT)

/*
** PRODUCTION DATE:9/10/2001
**
** CREATION DATE:9/10/2001
** AUTHOR: Joel Smith
** PURPOSE: Update and log station test limit changes
**
** MODIFICATION HISTORY
**
*/

AS

--Begin Log Insert

BEGIN TRANSACTION

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
		
		SELECT 	Station_Name,
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
		FROM SubTestLimits
		WHERE (Station_Name = @Station_Name_1) AND
			(SubTest_Name = @SubTest_Name_2) AND
			(ACSEEMode = @ACSEEMode_10) AND
			(SAP_Model_Name = @SAP_Model_Name_14)

--Check insert operation

	IF @@ERROR != 0
		BEGIN
			SET @TransReply = 'ABORT - Log Table Insert Failed'
			ROLLBACK TRANSACTION
			RETURN
		END
					
--Begin Table Update
			
	UPDATE SubTestLimits 

	SET  	UL	= @UL_3,
		LL	= @LL_4,
		strLimit	= @strLimit_5,
		flgLimit	= @flgLimit_6,
		Units	= @Units_7,
		Description	= @Description_8,
		Author	= @Author_9,
		SPCParm	= @SPCParm_11,
		Hard_UL	= @Hard_UL_12,
		Hard_LL	= @Hard_LL_13,
		SAP_Model_Name	= @SAP_Model_Name_14,
		Limit_Date	= (getdate()) 
	WHERE 	(Station_Name = @Station_Name_1) AND 
		(SubTest_Name = @SubTest_Name_2) AND
		(ACSEEMode = @ACSEEMode_10) AND
		(SAP_Model_Name = @SAP_Model_Name_14)
		
--Commit and Reply

	IF @@ERROR != 0
		BEGIN
			SET @TransReply = 'ABORT - SubTestLimit Update Failed'
			ROLLBACK TRANSACTION
			RETURN
		END
	ELSE
		BEGIN
			--SET @TransReply = 'Limit Table Updated'
			COMMIT TRANSACTION
			SET @TransReply = 'Limits Updated For Station (' + RTrim(@Station_Name_1) + '), SubTest (' + RTrim(@SubTest_Name_2) + '), SAP# (' + RTrim(@SAP_Model_Name_14) + ')'
			RETURN
		END


GO