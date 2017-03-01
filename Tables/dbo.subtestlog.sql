CREATE TABLE [dbo].[subtestlog] (
  [ACS_Serial] [char](20) NOT NULL,
  [Station] [char](20) NOT NULL,
  [SubTest_Name] [char](30) NULL,
  [Test_ID] [char](50) NULL,
  [Pass_Fail] [char](3) NULL,
  [strValue] [char](20) NULL,
  [intValue] [int] NULL,
  [floatValue] [real] NULL,
  [Units] [char](30) NULL,
  [Comment] [char](80) NULL,
  [STL_ID] [int] IDENTITY (485608686, 1)
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ACS_Serial]
  ON [dbo].[subtestlog] ([ACS_Serial])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Station]
  ON [dbo].[subtestlog] ([Station])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_SubTest_Name]
  ON [dbo].[subtestlog] ([SubTest_Name])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Test_ID]
  ON [dbo].[subtestlog] ([Test_ID])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [stlid]
  ON [dbo].[subtestlog] ([STL_ID])
  WITH (FILLFACTOR = 70)
  ON [PRIMARY]
GO