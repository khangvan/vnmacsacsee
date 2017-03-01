SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE  proc [dbo].[ame_Delete_BOM_Level_Station]
-- Define input parameters
	@station nchar(20) = NULL,
              @ProdOrder char(20) = ''
	
-- Define code
AS
	set nocount on

	--Verify that non-NULLable parameter(s) have values
	if @station is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
		select 'Error: You must specify a Station'
		return
	   end

	/*
	--Force delete all parts in station
	delete BOM_Level_Station where Station=@station
	if @@ERROR <> 0
	Begin
		select 'Error: Failed to delete to BOM Records'
		Return
	End
	*/	
	
	--Begin T-SQL Transaction
	-- Save record to  BOM_Level_Station table
             if len(rtrim(@ProdOrder)) > 0
            begin
	delete  dbo.BOM_Level_Station
	where Station=@station and ProdOrder = @ProdOrder
	if @@ERROR <> 0
	   Begin
		--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
		select 'Error: Failed to delete to BOM Records'
		Return
	   End
            end
            else
             begin
	delete  dbo.BOM_Level_Station
	where Station=@station
	if @@ERROR <> 0
	   Begin
		--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
		select 'Error: Failed to delete to BOM Records'
		Return
	   End
             end
	
	select 'OK'
-- Create the Stored Procedure
	return
GO