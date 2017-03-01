SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetSapSerialsInfo]
@sapserial char(20),
@acsserial char(20) OUTPUT,
@sapmodel char(20) OUTPUT,
@prodorder char(20) OUTPUT,
@Result char(20) OUTPUT
AS

declare @tffcid int

select @acsserial = acs_serial from [ACSEEState].[dbo].loci where psc_serial = @sapserial
-- sbarozzi change on 2011-06-24
-- new way to check @acsserial 
if (@acsserial is not null) and (rtrim(@acsserial)<>'')
begin
    select @sapmodel = sap_model , @prodorder = prodorder from [ACSEEState].[dbo].loci where psc_serial = @sapserial
    set @Result = 'OK'
end
else
begin
 set @Result='NOTFOUND'
end

select @Result, @sapserial, @acsserial, @sapmodel, @prodorder
GO