﻿SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE proc [dbo].[sp_get_subassembly_loci]
-- Define input parameters
	@acssn 	char(20) = NULL
	
-- Define code
AS
	set nocount on

	--Verify that non-NULLable parameter(s) have values
	if @acssn is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
		select 'Error: You must specify an ACS Serial Number'
		return
	   end
	begin transaction
	--See if Loci exists
	if not exists(select ACS_Serial from Loci 
		where ACS_Serial = @acssn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value. Loci %s does not exist.',
			--16,1, @acssn ) with nowait
		select 'Error: Loci ACS Serial Number does not exist.'
		return
	   end
	select 'OK'
	select 
		ACS_serial,
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
	 from Loci
		where Assembly_ACSSN = @acssn
	commit transaction
-- Create the Stored Procedure
GO