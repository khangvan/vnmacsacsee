SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_part_record]
-- Define input parameters
	@pname 		char(20) = NULL

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E110.1 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end

	--See if Part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E110.2 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end

	-- Get part information
	select Description,Status from Catalog
	where Part_No_Name=@pname
	if @@ERROR <>0
	   begin
		raiserror('E110.3 Undefined error. Unable to retrieve Catalog db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO