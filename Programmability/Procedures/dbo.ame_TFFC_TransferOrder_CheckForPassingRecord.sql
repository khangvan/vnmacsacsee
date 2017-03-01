SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_TransferOrder_CheckForPassingRecord]
@serial char(20),
@model char(20)
 AS
set nocount on


declare @assemid int
declare @acsserial char(20)
declare @lociacsserial char(20)
declare @test_TL_ID int

select @assemid = assem_id from assemblies where psc_serial = @serial

if @assemid is null
begin
    select @lociacsserial = acs_serial from [ACSEEState].[dbo].loci where   [ACSEEState].[dbo].loci.psc_serial = @serial
    if @lociacsserial is not null
    begin
        set @acsserial = @lociacsserial
    end
    else
    begin
       set @acsserial = @serial
    end
end
else
begin

    select @acsserial = acs_serial from assemblies where assem_id = @assemid
end


if exists (select TL_ID from testlog where acs_serial = @acsserial )
begin
select 'OK'
select acs_serial, sap_model, pass_fail from testlog where acs_serial = @acsserial
and test_date_time = (select max(test_date_time) from testlog where acs_serial = @acsserial )
end
else
begin
select 'NONE'
end
GO