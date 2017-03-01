CREATE TABLE [dbo].[SubTestLimitsLog] (
  [Station_Name] [char](20) NOT NULL,
  [SubTest_Name] [char](20) NOT NULL,
  [SAP_Model_Name] [char](20) NOT NULL,
  [Limit_Type] [char](1) NOT NULL,
  [UL] [float] NULL,
  [LL] [float] NULL,
  [strLimit] [char](40) NULL,
  [flgLimit] [char](1) NULL,
  [Units] [char](10) NULL,
  [Description] [char](50) NULL,
  [Author] [char](25) NULL,
  [ACSEEMode] [int] NOT NULL,
  [SPCParm] [char](1) NULL,
  [Hard_UL] [float] NULL,
  [Hard_LL] [float] NULL,
  [Limit_Date] [datetime] NOT NULL,
  [ProductGroup_Mask] [int] NULL,
  [STLL_ID] [int] IDENTITY (552418, 1),
  [Retire_Date] [datetime] NULL,
  [Limit_ID] [int] NULL,
  [Note_ID] [int] NULL,
  CONSTRAINT [PK_SubTestLimitsLog] PRIMARY KEY CLUSTERED ([STLL_ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_SAP_Model_Name]
  ON [dbo].[SubTestLimitsLog] ([SAP_Model_Name])
  ON [PRIMARY]
GO

CREATE INDEX [IDX_SubTest_Name]
  ON [dbo].[SubTestLimitsLog] ([SubTest_Name])
  ON [PRIMARY]
GO