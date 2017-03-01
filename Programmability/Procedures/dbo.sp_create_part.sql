SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_create_part]
-- Define input parameters
	@pname 	char(20) = NULL, @desc nchar(40) = NULL, 
	@status	char(1) = 'A' 		-- Catalog db
	
-- Define code
AS
	-- Define Local variables
	declare @pcount	int
	set @pcount = NULL -- Part_Count of new part

	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E101.1 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Part already exists
	if exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E101.2 Illegal Parameter Value. Part %s already exists.',
			16,1,@pname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction
		-- Increment Counter for Prot_No_Count in the Counters db
		exec sp_get_next_counter '5',@pcount OUTPUT -- Last_Part_No_Count
		if @pcount is NULL
		   Begin
			raiserror('E101.3 Serious error. Failed to update Counters db',17,1)
			Rollback Transaction
			return
		   End

		-- Save record to Catalog db
		Insert Catalog
		Values (@pcount, @pname, @desc, @status,256,256)
		if @@ERROR <> 0
		   Begin
			raiserror('E101.4 Serious error. Failed to append to Catalog db',17,1)
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure

GO