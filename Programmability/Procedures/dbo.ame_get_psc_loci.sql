SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO



CREATE  proc [dbo].[ame_get_psc_loci]
-- Define input parameters
	@pscsn 	char(20) = NULL
	
-- Define code
AS
	set nocount on
	--Verify that non-NULLable parameter(s) have values
	if @pscsn is NULL
	   begin
		/*raiserror(50011,10,1,'1.0101','Part Number')*/
		--raiserror ('E0001.0101 Illegal Parameter Value. You must specify an ACSSN name.',
			--16,1) with nowait
		select 'Error: You must specify an PSC Serial Number'
		return
	   end

	--See if  dbo.Loci exists
	if not exists(select PSC_Serial from  dbo.Loci WITH (NOLOCK) 
		where PSC_Serial = @pscsn )
	   begin
		--raiserror ('E0001.0103 Illegal Parameter Value.  dbo.Loci %s does not exist.',
			--16,1, @acssn ) with nowait
		select 'Error: PSC Serial Number does not exist!'

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
	 from  dbo.Loci WITH (NOLOCK) 
		where PSC_Serial = @pscsn

-- Create the Stored Procedure
GO