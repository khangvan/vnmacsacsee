CREATE TABLE [dbo].[FFC_EUG_Subtestlimits] (
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
  [OpportunitiesforFail] [int] NULL,
  [FFC_SO_Vendor] [char](20) NOT NULL,
  [FFC_SO_Plant] [char](10) NOT NULL,
  CONSTRAINT [PK_FFC_EUG_Subtestlimits] PRIMARY KEY CLUSTERED ([Station_Name], [SubTest_Name], [SAP_Model_Name], [ACSEEMode], [FFC_SO_Vendor], [FFC_SO_Plant])
)
ON [PRIMARY]
GO