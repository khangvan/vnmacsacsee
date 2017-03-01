CREATE TABLE [dbo].[BatchBuilds] (
  [BatchBuild_ID] [int] IDENTITY,
  [BatchBuild_Station_ID] [int] NULL,
  [BatchBuild_StationName] [char](30) NULL,
  [BatchBuild_ModelName] [char](30) NULL,
  [BatchBuild_ProductID] [int] NULL,
  [BatchBuild_BatchorNotIndicator] [int] NULL,
  [BatchBuild_Comment] [varchar](80) NULL,
  CONSTRAINT [PK_BatchBuilds] PRIMARY KEY CLUSTERED ([BatchBuild_ID])
)
ON [PRIMARY]
GO