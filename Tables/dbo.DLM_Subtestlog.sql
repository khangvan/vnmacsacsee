CREATE TABLE [dbo].[DLM_Subtestlog] (
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
  [STL_ID] [int] NOT NULL
)
ON [PRIMARY]
GO