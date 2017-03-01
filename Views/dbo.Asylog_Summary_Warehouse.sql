SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Asylog_Summary_Warehouse]
AS
SELECT     TOP 100 PERCENT dbo.Warehouse_asylog.ACS_Serial, dbo.Warehouse_asylog.Scanned_Serial AS Sub_ACS_Serial, 
                      dbo.[Catalog].Part_No_Name AS Sub_SAP_Model, dbo.Warehouse_asylog.Action_Date, 
	        dbo.Warehouse_asylog.Action_Date_Time
FROM         dbo.Warehouse_asylog INNER JOIN
                      dbo.[Catalog] ON dbo.Warehouse_asylog.Added_Part_No = dbo.[Catalog].Part_No_Count
WHERE     (LEN(dbo.Warehouse_asylog.Scanned_Serial) > 4) AND (SUBSTRING(dbo.Warehouse_asylog.Scanned_Serial, 1, 1) = 'S')
ORDER BY dbo.Warehouse_asylog.ACS_Serial



GO