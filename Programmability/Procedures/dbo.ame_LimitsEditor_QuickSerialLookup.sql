SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitsEditor_QuickSerialLookup]
@acsserial char(20)
 AS
select 
ACS_Serial, SAP_Model, Station, SubTest_Name, Test_ID, 
                      Pass_Fail, Test_Pass_Fail, strValue, intValue,floatValue, 
                      Units, STL_ID, Comment, FirstRun, Test_Date_Time, 
                      ACSEEMode
 from subtestlog_view WITH (NOLOCK) where acs_serial = @acsserial  order by Test_Date_time
GO