SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		/*Author*/
-- Create date: /*Create Date*/
-- Description:	/*Description*/
-- =============================================
CREATE PROCEDURE [dbo].[amevn_testreport]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SELECT * FROM dbo.subtestlog sv WHERE sv.ACS_Serial='G15FAEAXQ'
END
GO