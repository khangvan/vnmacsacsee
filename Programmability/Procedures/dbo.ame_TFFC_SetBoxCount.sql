SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_SetBoxCount]
@POTO char(20),
@model char(20),
@count int 
 AS
set nocount on
declare @boxcnt int

if exists ( select BOXCNT_ID from TFFC_BOXCOUNTER WHERE BOXCNT_PO_TO= rtrim(@POTO))
begin
  select @boxcnt = BOXCNT_ID  from TFFC_BOXCOUNTER WHERE BOXCNT_PO_TO= rtrim(@POTO)
  update TFFC_BOXCOUNTER set BOXCNT_Current = @count  WHERE BOXCNT_PO_TO= rtrim(@POTO)
end
else
begin
  insert into TFFC_BOXCOUNTER
   (
        BOXCNT_PO_TO,
         BOXCNT_Model, 
         BOXCNT_Current
   )
   values
    (
                @POTO,
                 @model,
                  @count
     )
end

   select @boxcnt = BOXCNT_ID  from TFFC_BOXCOUNTER WHERE BOXCNT_PO_TO= rtrim(@POTO)
   select BOXCNT_PO_TO, BOXCNT_Model, isnull(BOXCNT_Current,0) as BOXCNT_Current  from TFFC_BOXCOUNTER  where BOXCNT_ID = @boxcnt
GO