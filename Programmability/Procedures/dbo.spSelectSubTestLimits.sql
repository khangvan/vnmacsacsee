SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSelectSubTestLimits]
	(@StationName_1	[char](20),
	@SubTestName_2 [char](20),
	@Mode_3 [int],
	@SAP_Model_Name_4 [char](20))

/*
** PRODUCTION DATE:9/10/2001
**
** CREATION DATE:9/10/2001
** AUTHOR: Joel Smith
** PURPOSE: View the test limits and other details for a Station and
**		one of the SubTests, along with a history of past
**		changes to the test limits.
**
** MODIFICATION HISTORY
**
*/

AS

--Select the current limit record(s)
	
	    BEGIN
	
		SELECT Station_Name,
			SubTest_Name,
			Limit_Type,
			ACSEEMode, 
			UL,
			LL,
			strLimit,
			flgLimit,
			Units,
			Description,
			Author,
			SPCParm, 
			Hard_UL,
			Hard_LL,
			Limit_Date,
			SAP_Model_Name
		FROM SubTestLimits
		WHERE (ACSEEMode = @Mode_3) AND
			(Station_Name = @StationName_1) AND 
			(SubTest_Name = @SubTestName_2) AND
			(SAP_Model_Name = @SAP_Model_Name_4)
		
	    END

--Select the historical limit record(s)

	    BEGIN
	
		SELECT Station_Name,
			SubTest_Name,
			Limit_Type,
			ACSEEMode, 
			UL,
			LL,
			strLimit,
			flgLimit,
			Units,
			Description,
			Author,
			SPCParm, 
			Hard_UL,
			Hard_LL,
			Limit_Date,
			SAP_Model_Name
		FROM SubTestLimitsLog
		WHERE (ACSEEMode = @Mode_3) AND
			(Station_Name = @StationName_1) AND 
			(SubTest_Name = @SubTestName_2) AND
			(SAP_Model_Name = @SAP_Model_Name_4)
		ORDER BY Limit_Date DESC

	END



GO