SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_SetUnitBoxed]
@pscserial char(20),
@boxnumber int,
@boxnumberstring char(20)
 AS
set nocount on
declare @tffcacsserial char(20)
declare @acsserial char(20)


declare @ORTStatus  Char(5)
declare @ORTBin  char(5)
declare  @ORTStart  char(20)
declare @pscsn char(20)
declare @asmsn char(20) 
declare 	@SieveByte	int 
declare  @UnitStnByte int 
declare 	@LineByte int 
declare  @PlantByte int

declare @Test_ID char(50)
declare @Station char(20)
declare @ProdOrder char(20)
declare @Model char(20)
declare @nextstation char(20)

declare @tffcid int

select @tffcid = tffc_id from tffc_serialnumbers where rtrim(tffc_serialnumber) = rtrim(@pscserial)

if @tffcid is not null
begin
update tffc_serialnumbers set boxnumberchar = @boxnumberstring, boxnumberint=@boxnumber where tffc_id = @tffcid


select @tffcacsserial = tffc_acsserial from tffc_serialnumbers where tffc_id = @tffcid
select @acsserial = acs_serial from [ACSEEState].[dbo].loci where acs_serial = @tffcacsserial

if @acsserial is not null
begin
select @model= SAP_Model  ,@ORTStatus = ORT_Status, @ORTBin = ORT_Bin, @ORTStart = ORT_Start, @pscsn = PSC_Serial, @asmsn = Assembly_ACSSN, @SieveByte = SieveByte, @UnitStnByte= UnitStnByte, @LineByte=LineByte, 
@nextstation = Next_Station_Name, @PlantByte=PlantByte, @Test_ID=Test_ID,@Station = Station, @ProdOrder = ProdOrder
from [ACSEEState].[dbo].loci where ACS_Serial = @acsserial 


exec [ACSEEState].[dbo].ame_update_Loci @acsserial, @model, @ORTStatus, @ORTBin, @ORTStart,@pscsn, @asmsn, @SieveByte, @UnitStnByte, @LineByte, @PlantByte,'PRINTPACK', @Test_ID, @nextstation
end
select 'OK'
end
else
begin
    select 'NOTFOUND'
end
GO