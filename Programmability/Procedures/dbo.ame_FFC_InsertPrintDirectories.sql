SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_InsertPrintDirectories]
@Print_Dir_ID int, 
@Print_Dir_Name varchar(50), 
@Print_Dir_Line varchar(50), 
@Print_Dir_Path varchar(50), 
@Print_Dir_Notes varchar(50)
 AS
insert into FFC_PrintDirectories
(
Print_Dir_ID, Print_Dir_Name, Print_Dir_Line, Print_Dir_Path, Print_Dir_Notes
)
values
(
@Print_Dir_ID, @Print_Dir_Name, @Print_Dir_Line, @Print_Dir_Path, @Print_Dir_Notes
)
GO