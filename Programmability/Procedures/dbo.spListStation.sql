SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[spListStation]

/*
Station List (multi-use)
*/

 AS

SELECT 
	Station_Name,
	ProductGroup_Mask,
	Perform_Test
FROM
	Stations 
ORDER BY
	Station_Name ASC

GO