SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSelectModel]
	(@StationName_1 [char](20),
	@SubTestName_2 [char](20),
	@ACSEEMode_3 [int])

/*
** PRODUCTION DATE:10/4/2001
**
** CREATION DATE:10/4/2001
** AUTHOR: Joel Smith
** PURPOSE: Return a list of Model Names available to the stated Station
**
** MODIFICATION HISTORY
**
*/

AS
	SELECT DISTINCT SubTest_Name,
			Station_Name,
			ACSEEMode,
			SAP_Model_Name
	FROM SubTestLimits
	WHERE (Station_Name = @StationName_1) AND
		(SubTest_Name = @SubTestName_2) AND
		(ACSEEMode = @ACSEEMode_3)
GO