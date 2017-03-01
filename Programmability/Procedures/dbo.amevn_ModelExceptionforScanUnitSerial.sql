SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		/*Author*/
-- Create date: /*Create Date*/
-- Description:	/*Description*/
-- =============================================
CREATE PROCEDURE [dbo].[amevn_ModelExceptionforScanUnitSerial]
@Sapmodel nchar(30) ='RBP-QMBT2X-BK'
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @result nchar(20)
	if (EXISTS (SELECT * from sapmodelexception where sap_model =@Sapmodel ))
   BEGIN
   SET @result = 'YES'
   END
   ELSE
   BEGIN
    SET @result = 'NO'
   END
   SELECT @result AS Result
END
GO