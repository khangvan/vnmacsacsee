CREATE TABLE [dbo].[BCS_subtestlog] (
  [ACS_Serial] [char](20) NOT NULL,
  [Station] [varchar](140) NOT NULL,
  [SubTest_Name] [char](80) NULL,
  [Limit_Name] [char](80) NOT NULL,
  [Test_ID] [varchar](160) NULL,
  [Pass_Fail] [char](3) NULL,
  [strValue] [char](20) NULL,
  [intValue] [int] NULL,
  [floatValue] [real] NULL,
  [Units] [char](30) NULL,
  [Comment] [char](80) NULL,
  [STL_TL_ID] [int] NULL,
  [STL_ID] [int] IDENTITY (121731369, 1),
  CONSTRAINT [PK_BCS_subtestlog] PRIMARY KEY CLUSTERED ([STL_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCS_subtestlog]
  ADD CONSTRAINT [FK_BCS_subtestlog_BCS_testlog] FOREIGN KEY ([STL_TL_ID]) REFERENCES [dbo].[BCS_TestLog] ([TL_ID])
GO