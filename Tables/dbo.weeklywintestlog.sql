CREATE TABLE [dbo].[weeklywintestlog] (
  [ACS_Serial] [char](20) NOT NULL,
  [SAP_Model] [char](20) NULL,
  [Station] [char](20) NULL,
  [Test_ID] [char](50) NULL,
  [Pass_Fail] [char](3) NULL,
  [FirstRun] [char](2) NULL,
  [Test_Date_Time] [datetime] NULL,
  [ACSEEMode] [int] NULL,
  [TL_ID] [int] NOT NULL,
  CONSTRAINT [PK_weeklywintestlog] PRIMARY KEY CLUSTERED ([TL_ID])
)
ON [PRIMARY]
GO