SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE proc [dbo].[sp_update_loci]
-- Define input parameters
	@acssn 	char(20) = NULL, 
	@sapmodel nchar(20) = NULL, @ORTStatus  Char(5) = 'N',
	@ORTBin  char(5) = ' ', @ORTStart  char(20) = ' ',
	@pscsn char(20) =' ',@asmsn char(20) =' ',
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
		select 'Error: You must specifiy an ACS_Serial number'
		return
	   end
	if @sapmodel is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an SAP Model Number.',
			--16,1) with nowait
		select 'Error: You must specify an SAP Model Number.'
		return
	   end
	--Begin T-SQL Transaction
	begin transaction
	--See if Loci exists
	if not exists(select ACS_Serial from Loci 
		where ACS_Serial = @acssn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value. Loci %s does not exist.',
			--16,1, @acssn ) with nowait
		select 'Error: Loci does not exist!'
		return
	   end
		-- update record to Loci db
		update Loci
		set ORT_Status = @ORTStatus, ORT_Bin = @ORTBin, ORT_Start = @ORTStart,
			PSC_Serial = @pscsn,Assembly_ACSSN = @asmsn,SAP_Model = @sapmodel,
			SieveByte = @SieveByte,UnitStnByte = @UnitStnByte,
			LineByte = @LineByte, PlantByte = @PlantByte,
			Next_Station_Name=@NextStn, Last_Event_Date = getdate(),
			Test_ID=@TestID, Station=@Station
		where ACS_Serial = @acssn
		if @@ERROR <> 0
		   Begin
			--raiserror('E0001.0107 Serious error. Failed to update the Loci db',17,1)
			select 'Error: Failed to update the loci db'
			Rollback Transaction
			Return
		   End
	
		-- Save Record in LociLog
		insert LociLog (	ACS_serial,
				ORT_Status,  
				ORT_Bin,
				ORT_Start, 
				PSC_Serial, 
				Assembly_ACSSN,
				SAP_Model,
				SieveByte,
				UnitStnByte, 
				LineByte,
				PlantByte,
				Next_Station_Name,
				Last_Event_Date,
				Test_ID,
				Station)
		select 	ACS_serial,
			ORT_Status,  
			ORT_Bin,
			ORT_Start, 
			PSC_Serial, 
			Assembly_ACSSN,
			SAP_Model,
			SieveByte,
			UnitStnByte, 
			LineByte,
			PlantByte,
			Next_Station_Name,
			Last_Event_Date,
			Test_ID,
			Station
		 from loci where ACS_Serial = @acssn
		if @@ERROR <> 0
		   Begin
			--raiserror('E0001.0107 Serious error. Failed to update the Loci db',17,1)
			select 'Error: Failed to update LociLog db'
			Rollback Transaction
			Return
		   End
	--Commit T-SQL Transaction
	select 'OK'
	Commit Transaction
-- Create the Stored Procedure
GO