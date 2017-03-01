SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_BuildLimitsOfInterest] 
@user char(50),
@subtest_name char(20),
@station_name char(20),
@type char(1),
@acseemode int
 AS
set nocount on
insert into subtestlimitsselect  (acsuser, Set_DateTime,  SubTest_Name,station_name ,  Limit_Type,  ACSEEMode )
values ( @user, getdate(), @subtest_name,@station_name, @type,@acseemode)
GO