SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE  proc [dbo].[ame_PRT_Delete_BOM_Level_Station]
-- Define input parameters
	@station nchar(20) = NULL
	
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
--Begin T-SQL Transaction
	-- Save record to  BOM_Level_Station table
	delete  dbo.PRT_BOM_Level_Station
	where Station=@station
	if @@ERROR <> 0
	   Begin
		--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
		select 'Error: Failed to delete to BOM Records'
		Return
	   End
	select 'OK'
-- Create the Stored Procedure
	return
GO