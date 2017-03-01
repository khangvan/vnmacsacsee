SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_modify_productline]
-- Define input parameters
	@tname 		char(5) = NULL, @pscserial char(2)=NULL, @prodname char(10) = NULL,
	@finname char(20) = NULL, @psclastseq int = NULL
	-- must use other stored proceedures to modify Status and last update fields
	
-- Define code
AS
	-- Define Local variables
	declare @pscid char(2), @pname char(10), @pscseq int
	declare @fname char(20), @status char(1)
	declare @ldate datetime, @fcount int
	set @fcount=NULL

	--Verify that non-NULLable parameter(s) have values
	if @tname is NULL
	   begin
		raiserror ('E304.1 Illegal Parameter Value. You must specify a Top Model Number Prefix.',
			16,1) with nowait
		return
	   end
	--See if Top Model exists
	if not exists(select Status from Productlines 
		where Top_Model_Prfx=@tname)
	   begin
		raiserror ('E304.2 Illegal Parameter Value. Top Model Prefix %s does not exist.',
			16,1,@tname) with nowait
		return
	   end
	-- Begin transaction
	Begin Transaction
		-- Read in existing values
		exec sp_get_productline @tname, @pscid OUTPUT, @pname OUTPUT, @pscseq OUTPUT,
			@fname OUTPUT, @status OUTPUT
		if @@ERROR <> 0
	   	   begin
			raiserror ('E304.3 Read Error. Unable to sp_get_productline.',17,1)
			rollback transaction
		   end

		-- Modify non-nulls
		if @pscserial is not NULL
		   begin
			set @pscid = @pscserial
--			if exists(select Status from ProductLines
--				where (PSC_Serial_ID=@pscid and Status='A') and (not Top_Model_No=@tname) )
--			   begin
--				raiserror ('E304.4 Illegal Parameter Value. Active PSC Serial ID %s already exists.',
--					16,1,@pscid)
--				rollback transaction
--				return
--			   end
		   end

		if @prodname is not NULL
		   begin
			set @pname = @prodname
		   end
		if @finname is not NULL
		   begin
			set @fname = @finname
			if not exists(select Status from Stations
				where Station_Name=@fname and Status = 'A' and Gen_PSC_Serial='Y')
			   begin
				raiserror ('E304.5 Illegal Parameter Value. Active Finish station %s does not exist.',
					16,1,@fname) with nowait
				rollback transaction			
				return
	   		   end
		   end
		if (@psclastseq is not NULL) and (@psclastseq>0)
		   begin
			set @pscseq = @psclastseq
		   end

		-- Get station number
		select @fcount=Station_Count from Stations
			where Station_Name=@fname and Status = 'A'
		if @@ERROR <> 0
	   	   begin
			raiserror ('E304.6 Update Error. Unable to read Stations db record.',17,1)
			rollback transaction
			return
		   end

		-- Update Stations db record
		update ProductLines -- Note that Status does not get update here!
		SET PSC_Serial_ID=@pscid, Product_Name=@pname, Last_PSC_Serial_Seq=@pscseq,
			PSCGen_Station=@fcount	
		where Top_Model_Prfx=@tname
		if @@ERROR <> 0
	   	   begin
			raiserror ('E304.7 Update Error. Unable to update ProductLines db record.',17,1)
			rollback transaction
			return
		   end

	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure


GO