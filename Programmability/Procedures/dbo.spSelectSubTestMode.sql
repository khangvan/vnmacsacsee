SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSelectSubTestMode]
	(@StationName_1 [char](20) = NULL,
	@SubTestName_2 [char](20) = NULL)

/*
** PRODUCTION DATE:9/21/2001
**
** CREATION DATE:9/21/2001
** AUTHOR: Joel Smith
** PURPOSE: Return a list of SubTest Modes available to the stated Station
**
** MODIFICATION HISTORY
**
*/

AS
	SELECT DISTINCT SubTest_Name,
			Station_Name,
			ACSEEMode
	FROM SubTestLimits
	WHERE (Station_Name = @StationName_1) AND
		(SubTest_Name = @SubTestName_2)

GO