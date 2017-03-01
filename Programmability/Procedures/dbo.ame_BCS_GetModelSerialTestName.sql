SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_BCS_GetModelSerialTestName]
	-- Add the parameters for the stored procedure here
	@model char(30),
	@serial char(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select MODELSERIALTEST_Model, MODELSERIALTEST_Test from MODELSERIALTEST
	where MODELSERIALTEST_Model = @model
END

GO