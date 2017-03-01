CREATE TABLE [dbo].[Failures] (
  [Date_Tested] [datetime] NULL,
  [Test_Station] [char](30) NULL,
  [Product_Line] [char](10) NULL,
  [SubTest_Name] [char](30) NULL,
  [Qty_Tested] [int] NULL,
  [Qty_Fail] [int] NULL,
  [Prod] [char](10) NULL,
  [F_ID] [int] IDENTITY,
  [FirstRun] [char](2) NULL,
  CONSTRAINT [PK_Failures] PRIMARY KEY CLUSTERED ([F_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO