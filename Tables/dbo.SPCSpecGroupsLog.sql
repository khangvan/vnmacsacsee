CREATE TABLE [dbo].[SPCSpecGroupsLog] (
  [specgroup_id] [int] NOT NULL,
  [station_name] [char](20) NOT NULL,
  [subtest_name] [char](20) NOT NULL,
  [UL] [float] NOT NULL,
  [LL] [float] NOT NULL,
  [SampleSize] [int] NOT NULL
)
ON [PRIMARY]
GO