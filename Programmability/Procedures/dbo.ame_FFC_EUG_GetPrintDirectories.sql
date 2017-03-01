SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_EUG_GetPrintDirectories] 
@Vendor char(20) ='104341',
@Plant    char(10)='1000'
AS
select
Print_Dir_ID, 
Print_Dir_Name, 
Print_Dir_Line, 
Print_Dir_Path, 
Print_Dir_Notes
from
FFC_EUG_PrintDirectories
where FFC_SO_Vendor = @Vendor and FFC_SO_Plant =@Plant
GO