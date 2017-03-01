CREATE TABLE [dbo].[VNCapacityControl] (
  [ID] [int] IDENTITY,
  [ProductGroup] [varchar](30) NOT NULL,
  [TargetHRS] [varchar](10) NULL DEFAULT (0),
  [Line] [nvarchar](50) NULL,
  [TargetSHF] [varchar](10) NULL,
  [ManPW] [nchar](10) NULL,
  [LastestMan] [int] NOT NULL DEFAULT (0),
  [LastUpdate] [datetime] NULL,
  PRIMARY KEY CLUSTERED ([ID]),
  UNIQUE ([ProductGroup])
)
ON [PRIMARY]
GO