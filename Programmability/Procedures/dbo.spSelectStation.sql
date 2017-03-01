SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spSelectStation]

/*
** PRODUCTION DATE:9/10/2001
**
** CREATION DATE:9/10/2001
** AUTHOR: Joel Smith
** PURPOSE: Return a list of active test stations
**
** MODIFICATION HISTORY
**
*/

AS
	SELECT Station_Name,
		Description
	FROM dbo.Stations
	WHERE (Status = 'A') AND
		(Perform_Test = 'Y')
GO