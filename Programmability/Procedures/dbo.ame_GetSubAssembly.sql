SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_GetSubAssembly] 
	-- Add the parameters for the stored procedure here
@parentACS char(20), 
@subassemblypart char(20) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if len(rtrim(@subassemblypart)) < 1 or @subassemblypart is NULL 
	begin
	   select rtrim(scanned_serial) from asylog where acs_serial = @parentACS
	   and len(rtrim(scanned_serial)) > 0
	--   print 'got to A'
	end
	else
	begin
--	print 'Got to B'
	   select rtrim(scanned_serial) from asylog inner join
	   catalog on added_part_no = part_no_count
	   where acs_serial = @parentACS
	   and part_no_name=@subassemblypart
	   and len(rtrim(scanned_serial)) > 0
	end
END
GO