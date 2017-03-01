SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_TestDebug]
@ProdOrder char(20),
@acsserial char(20),
@usedserial char(20)
AS

set nocount on


declare @strLog char(300)

declare @tffcID int

set @tffcID = 1
set @strLog = 'consume1 pid = ' + convert(varchar,@@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + @acsserial +'] usedserial=['+ @usedserial +']   tffcID=[' + convert(varchar,@tffcID) +']'


print @strLog
GO