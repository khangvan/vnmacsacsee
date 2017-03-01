SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_last_PSC_Serial]
-- Define input parameters
	@sname 		char(20) = NULL, @tmodel	char(5) = NULL,
	@lpscseq	int	OUTPUT
-- Define code
AS
	--Define local variable(s)
	declare @scount int
	set @scount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E7.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @tmodel is NULL
	   begin
		raiserror ('E7.2 Illegal Parameter Value. You must specify a top model number.',
			16,1) with nowait
		return
	   end
	--Initialize return values 
	set @lpscseq = 0

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname)
	   begin
		raiserror ('E7.3 Illegal Parameter Value. Station %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Get Station information
	select @scount=Station_Count from Stations
	where Station_Name=@sname
	if @@ERROR <>0
	   begin
		raiserror('E7.4 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- Get PSC Serial Number information
	if @scount is not NULL
	   begin
		select @lpscseq=Last_PSC_Serial_Seq from ProductLines
		where PSCGen_Station=@scount and Top_Model_Prfx=@tmodel
		if @@ERROR <>0 -- Not finding it is a common occurance
	   	   begin
			set @lpscseq = 0
			return
	   	   end
	   end
-- Create the Stored Procedure


GO