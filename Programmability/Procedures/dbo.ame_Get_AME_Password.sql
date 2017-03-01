SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[ame_Get_AME_Password]
-- Define input parameters
	@User_Name 	char(20) = NULL

AS
set nocount on

if exists(select Pass_Word from AMEPasswords 
	where AMEPasswords.[User_Name]=@User_Name)
   begin
	select 'OK'
	select Pass_Word from AMEPasswords 
		where AMEPasswords.[User_Name]=@User_Name
   end
else
   begin
	select 'User Does not exist in AME Password DB.'
   end
GO