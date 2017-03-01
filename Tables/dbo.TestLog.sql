CREATE TABLE [dbo].[TestLog] (
  [ACS_Serial] [char](20) NOT NULL,
  [SAP_Model] [char](20) NULL,
  [Station] [char](20) NULL,
  [Test_ID] [char](50) NULL,
  [Pass_Fail] [char](3) NULL,
  [FirstRun] [char](2) NULL,
  [Test_Date_Time] [datetime] NULL,
  [ACSEEMode] [int] NULL,
  [TL_ID] [int] IDENTITY (2001560, 1),
  CONSTRAINT [PK_TestLog] PRIMARY KEY CLUSTERED ([TL_ID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ACS_Serial]
  ON [dbo].[TestLog] ([ACS_Serial])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_SAP_Model]
  ON [dbo].[TestLog] ([SAP_Model])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Station]
  ON [dbo].[TestLog] ([Station])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Test_Date_Time]
  ON [dbo].[TestLog] ([Test_Date_Time])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Test_ID]
  ON [dbo].[TestLog] ([Test_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO