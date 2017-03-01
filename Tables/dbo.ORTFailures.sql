CREATE TABLE [dbo].[ORTFailures] (
  [Date_Tested] [datetime] NULL,
  [Test_Station] [char](30) NULL,
  [Product_Line] [char](10) NULL,
  [SubTest_Name] [char](30) NULL,
  [Qty_Tested] [int] NULL,
  [Qty_Fail] [int] NULL,
  [Prod] [char](10) NULL
)
ON [PRIMARY]
GO