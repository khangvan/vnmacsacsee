CREATE TABLE [dbo].[SubTestLimits] (
  [Station_Name] [char](20) NOT NULL,
  [SubTest_Name] [char](20) NOT NULL,
  [SAP_Model_Name] [char](20) NOT NULL,
  [Limit_Type] [char](1) NOT NULL,
  [UL] [float] NULL,
  [LL] [float] NULL,
  [strLimit] [char](40) NULL,
  [flgLimit] [char](1) NULL,
  [Units] [char](10) NOT NULL,
  [Description] [char](50) NOT NULL,
  [Author] [char](25) NOT NULL,
  [ACSEEMode] [int] NOT NULL,
  [SPCParm] [char](1) NOT NULL,
  [Hard_UL] [float] NULL,
  [Hard_LL] [float] NULL,
  [Limit_Date] [datetime] NOT NULL,
  [ProductGroup_Mask] [int] NULL,
  [Limit_ID] [int] IDENTITY (4359, 1),
  [Note_ID] [int] NULL,
  [OpportunitiesforFail] [int] NULL,
  CONSTRAINT [PK_SubTestLimits] PRIMARY KEY NONCLUSTERED ([Station_Name], [SubTest_Name], [SAP_Model_Name], [ACSEEMode]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [ACSEEMode_i]
  ON [dbo].[SubTestLimits] ([ACSEEMode])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [hard_ll_i]
  ON [dbo].[SubTestLimits] ([Hard_LL])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [Hard_UL_i]
  ON [dbo].[SubTestLimits] ([Hard_UL])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [Limit_type_i]
  ON [dbo].[SubTestLimits] ([Limit_Type])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [LL_i]
  ON [dbo].[SubTestLimits] ([LL])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [Prod_i]
  ON [dbo].[SubTestLimits] ([ProductGroup_Mask])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [SAP_Model_Name_i]
  ON [dbo].[SubTestLimits] ([SAP_Model_Name])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [SPCParm_i]
  ON [dbo].[SubTestLimits] ([SPCParm])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [station_name_ci]
  ON [dbo].[SubTestLimits] ([Station_Name])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [strLimit_i]
  ON [dbo].[SubTestLimits] ([strLimit])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [subtestname_i]
  ON [dbo].[SubTestLimits] ([SubTest_Name])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [UL_i]
  ON [dbo].[SubTestLimits] ([UL])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO