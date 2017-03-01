SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[VIEW1]
AS
SELECT     TOP 20 dbo.assemblies.ACS_Serial, dbo.assemblies.SAP_Model_No, dbo.assemblies.PSC_Serial, dbo.assemblies.Start_Mfg, dbo.subtestlog.Station, 
                      dbo.subtestlog.SubTest_Name, dbo.subtestlog.Test_ID, dbo.subtestlog.Units, dbo.subtestlog.Pass_Fail, dbo.assemblies.End_Mfg
FROM         dbo.assemblies INNER JOIN
                      dbo.subtestlog ON dbo.assemblies.ACS_Serial = dbo.subtestlog.ACS_Serial

GO