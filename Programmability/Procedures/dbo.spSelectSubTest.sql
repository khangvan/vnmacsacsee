SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSelectSubTest]
	(@StationName_1 [char](20) = NULL)

/*
** PRODUCTION DATE:9/10/2001
**
** CREATION DATE:9/10/2001
** AUTHOR: Joel Smith
** PURPOSE: Return a list of SubTest(s) available to the stated Station
**
** MODIFICATION HISTORY
**
*/

AS
	SELECT DISTINCT SubTest_Name,
			Station_Name
	FROM SubTestLimits
	WHERE (Station_Name = @StationName_1)
GO