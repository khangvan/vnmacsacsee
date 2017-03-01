SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE VIEW [dbo].[Randy]
AS
SELECT     TOP 100 PERCENT *
FROM         dbo.SubTestLimits
WHERE     (Station_Name = 'MAMBAANALOG1') AND (SAP_Model_Name = '3-0473-04')
ORDER BY SubTest_Name

GO