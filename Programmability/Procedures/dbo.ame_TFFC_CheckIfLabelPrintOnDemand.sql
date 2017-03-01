SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_CheckIfLabelPrintOnDemand]
@BomPartName char(20),
@Station char(20),
@ProductionOrder char(20),
@acsserial char(20),
@PrintOnDemand char(20) OUTPUT
 AS
set nocount on

declare @printondemandresult int

select @printondemandresult = PRF_DemandOrPrePrint from NACS_PrintFileLookup where PRF_BomPartName = @BomPartName and PRF_Station = @Station
if @printondemandresult is not null
begin
if @printondemandresult =1 
   begin
      select @PrintOnDemand = TFFC_PrintOnDemand from TFFC_SerialNumbers where TFFC_ProdOrder = @ProductionOrder and TFFC_ReservedBy = @acsserial
   end
   else
   begin
      set @PrintOnDemand='D'
   end
end
else
begin
  set @PrintOnDemand = 'D'
end
GO