CREATE TYPE [dbo].[testLogRecord] AS TABLE (
  [test_ID] [varchar](160) NOT NULL,
  [testName] [varchar](50) NOT NULL,
  [unitSerial] [char](20) NOT NULL,
  [Model] [char](20) NOT NULL,
  [WorkCenter] [varchar](80) NOT NULL,
  [Station] [varchar](140) NOT NULL,
  [Pass_Fail] [char](3) NOT NULL,
  [FirstRun] [char](3) NULL,
  [ACSEEMode] [int] NOT NULL,
  [UsageMode] [char](10) NOT NULL,
  [TestDateTime] [datetime] NULL,
  [TL_ID] [int] NULL
)
GO