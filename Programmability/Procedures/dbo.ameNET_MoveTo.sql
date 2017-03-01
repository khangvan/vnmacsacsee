SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ameNET_MoveTo]
@acsserial varchar(20),
@station varchar(20),
@newstation varchar(20),
@user varchar(20),
@password varchar(20)
as
set nocount on


declare @acssn varchar(20)
declare @serial varchar(20)
declare @nstation varchar(20)

--Verify that non-NULLable parameter(s) have values
	if @acssn is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
--WDK exec ame_AddLociLogRecord 'unknown', 'unknown',@acssn,'unknown','ame_get_loci','Error: You must specify an ACS Serial ','error'

		select 'Error: You must specify an ACS Serial Number'
		return
	   end

	--See if  dbo.Loci exists
	if not exists(select ACS_Serial from  dbo.Loci WITH (NOLOCK) 
		where ACS_Serial = @acssn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value.  dbo.Loci %s does not exist.',
			--16,1, @acssn ) with nowait
-- WDK exec ame_AddLociLogRecord 'unknown', 'unknown',@acssn,'unknown','ame_get_loci','Error: ACS Serial Number does not exist','error'

		select 'Error: ACS Serial Number does not exist!'

		return
	   end
--select @serial=ACS_Serial, @station = Station, @nstation=Next_Station_Name,@model=SAP_Model from  dbo.Loci WITH (NOLOCK) 
--		where ACS_Serial = @acssn


	begin transaction


		update loci set Next_Station_Name=@newstation, Last_Event_Date = getdate(),
				 Station=@station
			where ACS_Serial = @acssn
			if @@ERROR <> 0
		   	Begin
				--raiserror('E0001.0107 Serious error. Failed to update the  dbo.Loci db',17,1)
				select 'Error: Failed to update the  dbo.Loci db'
				Rollback Transaction
				Return
		   	End


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
GO