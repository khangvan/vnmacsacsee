SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_saveTemplate]
@name char(50),
@subtest_name char(20),
@type char(1),
@acseeMode int
 AS
set nocount on
insert into subtesttemplates ( Set_Name, Set_DateTime,  SubTest_Name, Limit_Type,  ACSEEMode )
values ( @name,  getdate(), @subtest_name, @type, @acseeMode )
GO