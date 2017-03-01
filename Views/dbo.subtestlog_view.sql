SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE VIEW [dbo].[subtestlog_view] 
AS 
SELECT 
dbo.subtestlog.ACS_Serial , 
dbo.TestLog.SAP_Model , 
dbo.subtestlog.Station , 
dbo.subtestlog.SubTest_Name , 
dbo.subtestlog.Test_ID , 
dbo.subtestlog.Pass_Fail , 
dbo.TestLog.Pass_Fail AS Test_Pass_Fail , 
dbo.subtestlog.strValue , 
dbo.subtestlog.intValue , 
dbo.subtestlog.floatValue , 
dbo.subtestlog.Units , 
dbo.subtestlog.STL_ID , 
dbo.subtestlog.Comment , 
dbo.TestLog.FirstRun , 
dbo.TestLog.Test_Date_Time , 
dbo.TestLog.ACSEEMode 
FROM dbo.subtestlog WITH ( NOLOCK ) 
INNER JOIN dbo.TestLog WITH ( NOLOCK ) ON dbo.subtestlog.Test_ID = dbo.TestLog.Test_ID 


GO