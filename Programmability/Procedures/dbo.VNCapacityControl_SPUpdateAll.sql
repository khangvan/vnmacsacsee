SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		/*Author*/
-- Create date: /*Create Date*/
-- Description:	/*Description*/
-- =============================================
CREATE PROCEDURE /*procedure*/ [dbo].[VNCapacityControl_SPUpdateAll]
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DELETE  FROM [VNCapacityControl]
    -- Insert statements for procedure here
	INSERT INTO [VNCapacityControl] (
      [ProductGroup]
      ,[TargetHRS]
      ,[Line]
      ,[TargetSHF]
      ,[ManPW]
      ,[LastestMan]
      ,[LastUpdate])
  SELECT 
      [ProductGroup]
      ,[TargetHRS]
      ,[Line]
      ,[TargetSHF]
      ,[ManPW]
      ,[LastestMan]
      ,[LastUpdate] FROM [10.84.10.67\SIPLACE_2008R2EX].[PTR].[dbo].[CapacityControl]
END
GO