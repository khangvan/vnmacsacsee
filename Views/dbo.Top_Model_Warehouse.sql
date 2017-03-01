SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Top_Model_Warehouse]
AS
SELECT     dbo.Warehouse_TestLog.SAP_Model AS Top_Model, dbo.Warehouse_assemblies.PSC_Serial AS Top_Model_PSC_SN, 
	         dbo.Warehouse_TestLog.SAP_Model, dbo.Warehouse_subtestlog.ACS_Serial, 
                      dbo.Warehouse_assemblies.PSC_Serial, dbo.Warehouse_TestLog.Test_Date_Time, dbo.Warehouse_TestLog.Test_Date,
	         dbo.Warehouse_assemblies.Sales_Order, 
	         dbo.Warehouse_assemblies.Line_Item, 
                      dbo.Warehouse_TestLog.Pass_Fail AS TestPF, dbo.Warehouse_subtestlog.SubTest_Name, dbo.Warehouse_subtestlog.Station, 
	         dbo.Warehouse_subtestlog.Test_ID, dbo.Warehouse_TestLog.ACSEEMode, 
                      dbo.Warehouse_SubTestLimits.SPCParm, dbo.Warehouse_subtestlog.Pass_Fail AS subtestPF, dbo.Warehouse_subtestlog.strValue, 
	         dbo.Warehouse_subtestlog.intValue, dbo.Warehouse_subtestlog.floatValue, 
                      dbo.Warehouse_subtestlog.Units, dbo.Warehouse_subtestlog.Comment, dbo.Warehouse_SubTestLimits.Limit_Type, 
	         dbo.Warehouse_SubTestLimits.UL, dbo.Warehouse_SubTestLimits.LL, 
                      dbo.Warehouse_SubTestLimits.strLimit, dbo.Warehouse_SubTestLimits.flgLimit, dbo.Warehouse_SubTestLimits.Hard_UL, 
	         dbo.Warehouse_SubTestLimits.Hard_LL
FROM         dbo.Warehouse_subtestlog INNER JOIN
                      dbo.Warehouse_assemblies ON dbo.Warehouse_subtestlog.ACS_Serial = dbo.Warehouse_assemblies.ACS_Serial INNER JOIN
                      dbo.Warehouse_TestLog ON dbo.Warehouse_subtestlog.Test_ID = dbo.Warehouse_TestLog.Test_ID LEFT OUTER JOIN
                      dbo.Warehouse_SubTestLimits ON dbo.Warehouse_TestLog.SAP_Model = dbo.Warehouse_SubTestLimits.SAP_Model_Name AND 
                      dbo.Warehouse_TestLog.ACSEEMode = dbo.Warehouse_SubTestLimits.ACSEEMode AND 
                      dbo.Warehouse_subtestlog.SubTest_Name = dbo.Warehouse_SubTestLimits.SubTest_Name




GO