SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_create_label_format]
-- Define input parameters
	@sname 	char(20) = NULL, @fname char(20) = NULL,
	@status	char(1) = 'A' 		-- Products db
	
-- Define code
AS
	-- Define Local variables
	declare @scount	int
	set @scount = NULL -- SAP_Count of new SAP Model Number

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		--raiserror ('E201.1 Illegal Parameter Value. You must specify a SAP Model Number.',
			--16,1) with nowait
		return
	   end
	--See if Model already exists

	if exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		--raiserror ('E201.2 Illegal Parameter Value. Model %s already exists.',
			--16,1,@sname) with nowait
		return
	   end

	--Begin T-SQL Transaction
	Begin transaction
		-- Increment Counter for SAP_Count in the Counters db
		exec sp_get_next_counter '8',@scount OUTPUT -- Last_SAP_Counter
		if @scount is NULL
		   Begin
			--raiserror('E201.3 Serious error. Failed to update Counters db',17,1)
			Rollback Transaction
			return
		   End

		-- Save record to Products db
		Insert Products
		Values (@scount, @sname, @fname, @status)
		if @@ERROR <> 0
		   Begin
			--raiserror('E201.4 Serious error. Failed to append to Products db',17,1)
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	Commit Transaction
-- Create the Stored Procedure

GO