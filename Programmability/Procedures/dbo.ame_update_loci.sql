﻿SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[ame_update_loci]
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
	declare @oldPSC char(20)

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

	--Check to see if PSC Serial already exists
	select @oldPSC=PSC_Serial from dbo.Loci  WITH (NOLOCK) 
		where ACS_Serial = @acssn
	if @@ERROR <> 0
   	   begin
		select 'Loci does not exist'
		return
	   end

	--Begin T-SQL Transaction
	begin transaction
	--See if  dbo.Loci exists
	if not exists(select ACS_Serial from  dbo.Loci  WITH (NOLOCK) 
		where ACS_Serial = @acssn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value.  dbo.Loci %s does not exist.',
			--16,1, @acssn ) with nowait
		select 'Error:  dbo.Loci does not exist!'
		return
	   end
		-- update record to  dbo.Loci db
		if len(ltrim(@oldPSC))>2
		   begin
			update  dbo.Loci
			set ORT_Status = @ORTStatus, ORT_Bin = @ORTBin, ORT_Start = @ORTStart,
				Assembly_ACSSN = @asmsn,SAP_Model = @sapmodel,
				SieveByte = @SieveByte,UnitStnByte = @UnitStnByte,
				LineByte = @LineByte, PlantByte = @PlantByte,
				Next_Station_Name=@NextStn, Last_Event_Date = getdate(),
				Test_ID=@TestID, Station=@Station
			where ACS_Serial = @acssn
			if @@ERROR <> 0
		   	Begin
				--raiserror('E0001.0107 Serious error. Failed to update the  dbo.Loci db',17,1)
				select 'Error: Failed to update the  dbo.Loci db'
				Rollback Transaction
				Return
		   	End
		   end
		else
		   begin
			update  dbo.Loci
			set ORT_Status = @ORTStatus, ORT_Bin = @ORTBin, ORT_Start = @ORTStart,
				PSC_Serial = @pscsn,Assembly_ACSSN = @asmsn,SAP_Model = @sapmodel,
				SieveByte = @SieveByte,UnitStnByte = @UnitStnByte,
				LineByte = @LineByte, PlantByte = @PlantByte,
				Next_Station_Name=@NextStn, Last_Event_Date = getdate(),
				Test_ID=@TestID, Station=@Station
			where ACS_Serial = @acssn
			if @@ERROR <> 0
		   	Begin
				--raiserror('E0001.0107 Serious error. Failed to update the  dbo.Loci db',17,1)
				select 'Error: Failed to update the  dbo.Loci db'
				Rollback Transaction
				Return
		   	End
		   end

		-- Save Record in  dbo.LociLog
		insert  dbo.LociLog (	ACS_serial,
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
		 from  dbo.Loci WITH (NOLOCK) where ACS_Serial = @acssn
		if @@ERROR <> 0
		   Begin
			--raiserror('E0001.0107 Serious error. Failed to update the  dbo.Loci db',17,1)
			select 'Error: Failed to update  dbo.LociLog db'
			Rollback Transaction
			Return
		   End
	--Commit T-SQL Transaction
	select 'OK'
	Commit Transaction
-- Create the Stored Procedure
GO