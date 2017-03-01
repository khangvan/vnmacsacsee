SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_get_next_counter]
-- Define input parameters
	@code	int = NULL,
	@count	int OUTPUT
-- Define Code
AS
	-- Initialize variables
	set @count = NULL

	-- Verify that non-NULLable parameter has value
	if @code is NULL
	   begin
		set @count = NULL -- a null return value is an error
print 'code is null'
		return
	   end
	-- Verify that we are protected within an existing transaction
	if @@TRANCOUNT = 0
	   begin
		set @count = NULL -- a null return value is an errorE0001.0101
		/*raiserror('E0000.0101 You may only execute sp_get_next_counter within an existing T-SQL Transaction!',17,1)
		*/
print 'trancount'
print @@trancount
		raiserror(50010,10,1,'0.0101','sp_get_next_counter')
		return
	   end
	-- Increment Counter for code in the Counters db
	select @count=Last_Value from Counters 
		where Counter_Code=@code -- Last_foo_Count
	if @@ERROR <>0
	   Begin
		set @count = NULL -- a null return value is an error
print ' error 1'
		return
	   End
	set @count = @count + 1
	update Counters SET Last_Value = @count
		where Counter_Code=@code -- Last_foo_Count
	if @@ERROR <> 0
	   Begin
		set @count = NULL -- a null return value is an error
print ' error 2'
print @@error
		Return
	   End
print @count

-- Create stored procedure
GO