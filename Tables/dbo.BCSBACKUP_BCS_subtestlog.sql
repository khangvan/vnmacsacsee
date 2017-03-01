CREATE TABLE [dbo].[BCSBACKUP_BCS_subtestlog] (
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
  [STL_ID] [int] NOT NULL
)
ON [PRIMARY]
GO