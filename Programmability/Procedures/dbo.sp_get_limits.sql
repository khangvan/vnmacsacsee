SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_limits]
-- Define input parameters
	@sname 		char(20) = NULL
	

-- Define code
AS	
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E16.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	--See if Station exits
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E16.2 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	--Go get it!
	select * from subTestLimits where Station_Name=@sname

	-- Create the Stored Procedure

GO