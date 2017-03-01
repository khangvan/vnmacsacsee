SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_GetBoxCount]
@POTO char(20)
 AS
set nocount on
declare @boxcnt int

if exists ( select BOXCNT_ID from TFFC_BOXCOUNTER WHERE BOXCNT_PO_TO= rtrim(@POTO))
begin
   select @boxcnt = BOXCNT_ID  from TFFC_BOXCOUNTER WHERE BOXCNT_PO_TO= rtrim(@POTO)
   select BOXCNT_PO_TO, BOXCNT_Model, isnull(BOXCNT_Current,0) from TFFC_BOXCOUNTER  where BOXCNT_ID = @boxcnt
end
else
begin
   select 'NONE' as BOXCNT_PO_TO,'NONE' as BOXCNT_Model ,0 as BOXCNT_Current
end
GO