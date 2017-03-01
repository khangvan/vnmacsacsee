SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_SubAssemblyPath_AddSerial]
@user char(50),
@type int,
@serial char(20)
 AS

if @type = 1 
begin
   insert into SubAssemblyPathLookup
   (
      user_id,
      Lookup_Type,
      ACS_Serial
   )
   values
    (
       @user,
       @type,
       @serial
     )
end
else
begin
   insert into SubAssemblyPathLookup
   (
      user_id,
      Lookup_Type,
      PSC_Serial
   )
   values
    (
       @user,
       @type,
       @serial
     )
end
GO