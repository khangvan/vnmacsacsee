CREATE TABLE [dbo].[dlm_subtestlimits] (
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
  [Limit_ID] [int] NOT NULL,
  [Note_ID] [int] NULL,
  [OpportunitiesforFail] [int] NULL
)
ON [PRIMARY]
GO