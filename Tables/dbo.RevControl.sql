CREATE TABLE [dbo].[RevControl] (
  [PreRelease_BOM_ECO] [int] NULL,
  [PreRelease_BOM_Date] [datetime] NULL,
  [Production_BOM_ECO] [int] NULL,
  [Production_BOM_Date] [datetime] NULL,
  [Depricated_BOM_ECO] [int] NULL,
  [Depricated_BOM_Date] [datetime] NULL,
  [PreRelease_Limit_Ref] [int] NULL,
  [PreRelease_Limit_Date] [datetime] NULL,
  [Production_Limit_Ref] [int] NULL,
  [Production_Limit_Date] [datetime] NULL,
  [Depricated_Limit_Ref] [int] NULL,
  [Depricated_Limit_Date] [datetime] NULL
)
ON [PRIMARY]
GO