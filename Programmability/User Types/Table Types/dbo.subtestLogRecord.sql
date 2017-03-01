CREATE TYPE [dbo].[subtestLogRecord] AS TABLE (
  [test_ID] [varchar](160) NOT NULL,
  [testName] [varchar](50) NOT NULL,
  [station_name] [varchar](140) NOT NULL,
  [step_name] [varchar](80) NOT NULL,
  [limit_name] [varchar](80) NOT NULL,
  [strValue] [varchar](80) NULL,
  [intValue] [int] NULL,
  [floatValue] [real] NULL,
  [unitSerial] [char](20) NOT NULL,
  [Model] [char](20) NOT NULL,
  [WorkCenter] [varchar](80) NOT NULL,
  [Pass_Fail] [char](3) NOT NULL,
  [Units] [char](30) NOT NULL,
  [Comment] [char](50) NULL,
  [TL_ID] [int] NULL
)
GO