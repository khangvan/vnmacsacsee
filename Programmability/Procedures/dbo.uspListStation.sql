SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspListStation]
AS
set nocount on
SELECT 
	Station_Name,
	ProductGroup_Mask,
	Perform_Test
FROM
	[ACS EE].dbo.Stations 
ORDER BY
	Station_Name ASC

GO