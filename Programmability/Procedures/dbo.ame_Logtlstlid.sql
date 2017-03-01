SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Logtlstlid] AS
declare @nmaxtlid int
declare @nmaxstlid int



select @nmaxtlid =   max(TL_ID) from TRN_testlog
select @nmaxstlid =  max(STL_ID) from TRN_subtestlog


exec ame_LogSuccess 
'Loaded testlog, subtestlog',
0,
'ame_Logtlstlid',
'new max tl_id, stl_id',
@nmaxtlid,
@nmaxstlid,
NULL,
'  ',
'wdkurth'
GO