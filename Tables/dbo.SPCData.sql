CREATE TABLE [dbo].[SPCData] (
  [sample_id] [int] IDENTITY,
  [specgroup_id] [int] NOT NULL,
  [RunTotal] [float] NOT NULL,
  [Maxm] [float] NOT NULL,
  [Minm] [float] NOT NULL,
  [PointCount] [int] NOT NULL,
  [SampleSize] [int] NOT NULL,
  [BeginDate] [smalldatetime] NULL,
  [Ignored] [nvarchar](1) NULL
)
ON [PRIMARY]
GO