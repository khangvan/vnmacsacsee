SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE  proc [dbo].[ame_create_loci]
-- Define input parameters
	@acssn 	char(20) = NULL, @sapmodel nchar(20) = NULL, 
	@SieveByte	int = 0, @UnitStnByte int = 0,
	@LineByte int = 0, @PlantByte int = 0,
	@NextStn char(20) = NULL,
	@TestID char(50)=NULL,
	@Station char(20)=NULL
	
-- Define code
AS
	set nocount on

	--Verify that non-NULLable parameter(s) have values
	if @acssn is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
		select 'Error: You must specify an ACS SN'
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
		begin transaction
	--See if  dbo.Loci already exists
	if exists(select ACS_Serial from dbo.Loci WITH (NOLOCK) 
		where ACS_Serial = @acssn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value.  dbo.Loci %s already exists.',
			--16,1, @acssn ) with nowait
		select 'Error:  dbo.Loci already exists.'
		return
	   end
			-- Save record to  dbo.Loci db
		Insert  dbo.Loci
		Values (@acssn, 'N', ' ', ' ',' ',' ',@sapmodel,@SieveByte,
			@UnitStnByte, @LineByte, @PlantByte,@NextStn,getdate(),@TestID,@Station)
		if @@ERROR <> 0
		   Begin
			--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
			select 'Error: Failed to append to  dbo.Loci db'
			Rollback Transaction
			Return
		   End
		-- Save record to  dbo.LociLog db
		Insert  dbo.LociLog
		Values (@acssn, 'N', ' ', ' ',' ',' ',@sapmodel,@SieveByte,
			@UnitStnByte, @LineByte, @PlantByte,@NextStn,getdate(),@TestID,@Station)
		if @@ERROR <> 0
		   Begin
			--raiserror('E0001.0107 Serious error. Failed to append to  dbo.Loci db',17,1)
			select 'Error: Failed to append to  dbo.LociLog db'
			Rollback Transaction
			Return
		   End
	
	--Commit T-SQL Transaction
	select 'OK'
	Commit Transaction
-- Create the Stored Procedure
	return
GO