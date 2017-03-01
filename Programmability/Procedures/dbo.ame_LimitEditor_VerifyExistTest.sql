SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_VerifyExistTest]
@testname char(20),
@exist int OUTPUT
 AS
set nocount on
declare @numfound int

set @exist = 0

select @numfound =  count(*) from subtestlimits where Station_Name = @testname 
if @numfound > 0
begin
   set @exist = 1
end
GO