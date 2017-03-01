SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_productline]
-- Define input parameters
	@tname 		char(5) = NULL, @pscid		char(2) OUTPUT,
	@pname  	char(10) OUTPUT, @pscseq 	int OUTPUT,
	@fname  	char(20) OUTPUT,  @status	char(1) OUTPUT
	
-- Define code
AS
	-- Init local variable
	declare @fcount int
	set @fcount = NULL
	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E305.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end

	--See if Top Model exists
	if not exists(select Status from ProductLines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E305.2 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end

	-- Get Top Model information
	select  @pscid=PSC_Serial_ID, @pname=Product_Name, @pscseq=Last_PSC_Serial_Seq,
		@fcount=PSCGen_Station, @status=Status from ProductLines
	where Top_Model_Prfx=@tname
	if @@ERROR <>0
	   begin
		raiserror('E305.3 Undefined error. Unable to retrieve ProductLines db data.',17,1)
		return
	   end
	-- Get finish station name
	select @fname=Station_Name from Stations
	where Station_Count=@fcount
	if @@ERROR <>0
	   begin
		raiserror('E305.4 Undefined error. Unable to retrieve Stations db data.',17,1)
		return
	   end


-- Create the Stored Procedure


GO