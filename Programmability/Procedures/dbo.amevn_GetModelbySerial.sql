SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		/*Author*/
-- Create date: /*Create Date*/
-- Description:	/*Description*/
-- =============================================
CREATE PROCEDURE [dbo].[amevn_GetModelbySerial]
@Serial varchar(30) 
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @Model nchar(30)
SELECT   top 1 @Model= SAP_Model  FROM ACSEEState.dbo.locilog
WHERE ACS_Serial <> '-' 
aND SAP_Model <>'NO_MATERIAL'
AND ACSEEState.dbo.locilog.ACS_Serial = @Serial
ORDER BY Last_Event_Date DESC

SELECT @Model AS SAP_Model

END
GO