SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Do_Overrides]
@sname char(20),
@mname char(20)
 AS
set nocount on

declare @part char(20)

declare cur_BOMOVerrides CURSOR FOR
select Part_Number from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ( select BOMO_Part from BOMOverride_Parts)

open cur_BOMOverrides


FETCH NEXT FROM cur_BOMOverrides into @part
WHILE @@FETCH_STATUS = 0
BEGIN

   select * from    BOM_Level_Station where Station = @sname and SAP_Model = @mname and Part_Number in 
                      (
                          select BOMP_Part from BOMOverrides_PartDeletes inner join BOM_Overrides_Parts on BOMP_OverrideID=BOMO_ID
                          where BOMO_Part = @part
                      )
FETCH NEXT FROM cur_BOMOverrides into @part
END


close cur_BOMOverrides
deallocate cur_BOMOverrides
GO