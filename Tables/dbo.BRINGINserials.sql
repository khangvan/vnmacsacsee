CREATE TABLE [dbo].[BRINGINserials] (
  [topserial] [nchar](20) NULL,
  [model] [nchar](20) NULL,
  [station] [varchar](50) NULL,
  [subtestname] [varchar](50) NULL,
  [testid] [varchar](50) NULL,
  [passfail] [nchar](10) NULL,
  [testpassfail] [nchar](10) NULL,
  [strvalue] [varchar](50) NULL,
  [intvalue] [int] NULL,
  [floatvalue] [float] NULL,
  [Units] [nchar](10) NULL,
  [id] [int] NULL,
  [comment] [varchar](50) NULL,
  [firstrun] [varchar](50) NULL,
  [testdatetime] [datetime] NULL,
  [mode] [int] NULL
)
ON [PRIMARY]
GO