SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  proc [dbo].[ame_Insert_BOM_Level_Station]
-- Define input parameters
	@station nchar(20) = NULL,
	@sapmodel nchar(20) = NULL,
	@partnumber nchar(20) = NULL,
	@rev char(3) = ' ',
	@desc nchar(50) = ' ',
	@acseemode int = 0,
	@qnty int = 1,
	@bomlevel int=1,
              @part_type char(5)=' ',
              @ProdOrder nchar(20) = ''
	
-- Define code
AS
	set nocount on
	declare @bomdatetime smalldatetime
	set @bomdatetime = getdate()

	--Verify that non-NULLable parameter(s) have values
	if @station is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
		select 'Error: You must specify a Station'
		return
	   end
	if @sapmodel is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an SAP Model Number.',
			--16,1) with nowait
		select 'Error: You must specificy an SAP Model Number'
		return
	   end
--Begin T-SQL Transaction
	-- Save record to  BOM_Level_Station table
	Insert  dbo.BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
	Values (@station,@sapmodel,@partnumber,@rev,@desc,@bomdatetime,@acseemode,
		@qnty,@bomlevel, @part_type,@ProdOrder)
	if @@ERROR <> 0
	   Begin
		--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
		select 'Error: Failed to append to BOM Record'
		Return
	   End
	select 'OK'
-- Create the Stored Procedure
	return
GO