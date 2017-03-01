CREATE TABLE [dbo].[SPCSpecGroups] (
  [specgroup_ID] [int] IDENTITY (0, 1),
  [station_name] [char](20) NOT NULL,
  [subtest_name] [char](20) NOT NULL,
  [UL] [float] NOT NULL,
  [LL] [float] NOT NULL,
  [SampleSize] [int] NOT NULL,
  CONSTRAINT [PK_SPCSpecGroups] PRIMARY KEY CLUSTERED ([specgroup_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO