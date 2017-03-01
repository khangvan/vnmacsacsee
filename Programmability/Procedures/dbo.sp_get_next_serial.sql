SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO


CREATE proc [dbo].[sp_get_next_serial]
-- Define input parameters
	@PrefixType	char(3),
	@Prefix 	char(2)
-- Define Code
AS
	declare @count int
	declare @stamp datetime
	-- Initialize variables
	--set @count =0
	set @stamp = getdate()
	set nocount on


--select 'yo' 
--return
	begin transaction
	-- Increment Counter for code in the Counters db
	select @count=Counter from Serialization 
		where  Prefix_Type=@PrefixType and Prefix=@Prefix -- Last_foo_Count
	if @@ERROR <>0
	   Begin
		select 'Error Reading counter'
		Rollback
		return 
	   End
	set @count = @count + 1
	update Serialization SET Counter = @count
		where  Prefix_Type=@PrefixType and Prefix=@Prefix -- Last_foo_Count
	if @@ERROR <> 0
	   Begin
		select 'Error updating counter'
		Rollback		
		Return
	   End
	update Serialization set Last_Event_Date = @stamp
	where  Prefix_Type=@PrefixType and Prefix=@Prefix -- Last_foo_Count
	if @@ERROR <> 0
	   Begin
		select 'Error datetime stamping counter'
		Rollback
		Return
	   End

	select 'OK'
	select * from serialization
		where Prefix_Type=@PrefixType and Prefix=@Prefix
	commit transaction
-- Create stored procedure
GO