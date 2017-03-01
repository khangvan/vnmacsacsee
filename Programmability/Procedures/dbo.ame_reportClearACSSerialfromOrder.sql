SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_reportClearACSSerialfromOrder]
@acsserial char(20),
@prodorder char(20)
 AS

set nocount on
declare @tffcid int
declare @paddedprodorder char(30)

if len(rtrim(@acsserial)) > 2 and len(rtrim(@prodorder)) > 5
begin

   set @paddedprodorder = RIGHT('000000000000' + rtrim(@prodorder), 12) 

   select @tffcid = tffc_id from tffc_serialnumbers where tffc_reservedby = @acsserial and tffc_prodorder = @paddedprodorder
   
   if @tffcid is not null
   begin
       update tffc_serialnumbers set tffc_reserved=0, tffc_consumed=0, tffc_reservedby='' where tffc_reservedby=@acsserial and tffc_prodorder = @paddedprodorder

       update [ACSEEState].[dbo].loci set psc_serial = '' where acs_serial = @acsserial  --and prodorder=@paddedprodorder
    
        select 'DONE' as status
     end
      else
       begin
             select 'Not Found' as status
       end
end
else
begin
   select 'Not Valid Serial or Production Order' as status
end
GO