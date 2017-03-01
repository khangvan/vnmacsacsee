SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_DLM_LoadData]
@maxtlid int,
@maxstlid int,
@maxstllid int,
@maxstationcount int,
@maxasylogid int,
@maxassemid int,
@maxlimitid int,
@maxpartnocount int,
@maxsapcount int,
@maxflgflid int
AS
set nocount on
GO