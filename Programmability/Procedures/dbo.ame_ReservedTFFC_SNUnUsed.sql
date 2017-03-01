SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_ReservedTFFC_SNUnUsed]
-- Add the parameters for the stored procedure here
@Prodorder NCHAR(20)
AS
DECLARE @Result nchar(10)
BEGIN
	UPDATE TFFC_SerialNumbers
	SET [TFFC_Reserved] = 0
	,   [TFFC_Consumed] = 0
	WHERE TFFC_SerialNumber IN (
		SELECT TFFC_SerialNumber
		FROM TFFC_SerialNumbers s
		WHERE s.TFFC_ProdOrder = @Prodorder
			AND s.TFFC_Material = '740045100'
			AND NOT EXISTS (
			SELECT *
			FROM TestLog t
			WHERE t.station LIKE 'HALOFOCUS%'
				AND s.TFFC_SerialNumber = t.ACS_Serial
			)
		)

		--IF @@ROWCOUNT = 0
		--BEGIN
		--	SET @Result='NG-No revert '
		--END
		--ELSE IF @@ROWCOUNT > 0
		--BEGIN 
		--	SET @Result= 'OK-Revert ' + LTRIM(STR(@@ROWCOUNT,10))
		--end

		--SELECT @Result 
END
GO