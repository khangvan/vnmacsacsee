CREATE TABLE [dbo].[BCS_TestLog] (
  [ACS_Serial] [char](20) NOT NULL,
  [SAP_Model] [char](20) NULL,
  [TestName] [varchar](50) NOT NULL,
  [WorkCenter] [varchar](80) NOT NULL,
  [Station] [varchar](140) NULL,
  [Test_ID] [char](160) NULL,
  [Pass_Fail] [char](3) NULL,
  [FirstRun] [char](2) NULL,
  [Test_Date_Time] [datetime] NULL,
  [ACSEEMode] [int] NULL,
  [UsageMode] [char](10) NULL,
  [TL_ID] [int] IDENTITY (2001560, 1),
  CONSTRAINT [PK_BCS_TestLog] PRIMARY KEY CLUSTERED ([TL_ID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO