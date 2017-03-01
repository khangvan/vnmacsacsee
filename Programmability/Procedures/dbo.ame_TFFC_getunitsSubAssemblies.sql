SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_getunitsSubAssemblies]
@aserial char(20),
@scannedbasepartno char(20) OUTPUT,
@scannedbaseserial char(20) OUTPUT,
@scannedscannerpartno char(20) OUTPUT,
@scannedscannerserial char(20) OUTPUT
 AS
set nocount on

declare @sapmodel char(20)

declare @asylogid int

declare @scannedserial char(20)
declare @partnoname char(20)
declare @kicksubmodel char(20)
declare @kicksubdescription char(80)
declare @ipos int

declare cur_scannedparts CURSOR FOR
select asylog.scanned_serial, catalog.part_no_name,Tffc_kicksub_Model, tffc_kicksub_description  from asylog 
inner join catalog on added_part_no = part_no_count
inner join tffc_kicksub on part_no_name = tffc_KICKSUB_PART
where acs_serial = @aserial  and TFFC_KICKSUB_Model = @sapmodel



set @scannedscannerpartno = ''
set @scannedscannerserial = ''
set @scannedbasepartno=''
set @scannedbaseserial = ''

select @sapmodel = sap_model from [ACSEEState].[dbo].loci where acs_serial = @aserial

print @sapmodel

if @sapmodel is not null
begin



   open cur_scannedparts

   FETCH  NEXT FROM cur_scannedparts into  @scannedserial, @partnoname, @kicksubmodel, @kicksubdescription


   WHILE @@FETCH_STATUS = 0 
    begin

       select @ipos =charindex('SCANNER',@kicksubdescription)
       if @ipos > 0 
       begin
                set @scannedscannerpartno = @partnoname
                set @scannedscannerserial = @scannedserial
       end

       select @ipos =charindex('BASE',@kicksubdescription)
       if @ipos > 0 
       begin
                set @scannedbasepartno = @partnoname
                set @scannedbaseserial = @scannedserial
       end

       FETCH  NEXT FROM cur_scannedparts into  @scannedserial, @partnoname, @kicksubmodel, @kicksubdescription
    end
 --
  select 'OK' as result, @scannedbasepartno as 'BASEPART', @scannedbaseserial as 'BASESERIAL', @scannedscannerpartno as 'SCANNERPART', @scannedscannerserial as 'SCANNERSERIAL'
end
else
begin
  select 'No model found in Loci' as result
print 'abc'
end
GO