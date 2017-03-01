SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_VerifyModelExists] 
@model char(20),
@found int OUTPUT
AS
set nocount on

declare @countmodel int

select @countmodel = count(*) from products where SAP_Model_Name = RTRIM(@model)

if @countmodel = 0
   begin
      set @found = 0
   end
else
   begin
      set @found = 1
   end
GO