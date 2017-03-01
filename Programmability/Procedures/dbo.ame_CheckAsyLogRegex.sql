SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_CheckAsyLogRegex]
	-- Add the parameters for the stored procedure here
	@partnoname char(20),
	@serialnumber char(20),
	@acstraveler char(20)=NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists ( select scanned_serial from asylog 
	             inner join catalog on added_part_no = part_no_count
				 where Part_No_Name=@partnoname 
				 and scanned_serial = @serialnumber
				 )
				 begin
				    select 'Serial number already scanned'
				END
				else
				begin
	select 'OK'
	end
END
GO