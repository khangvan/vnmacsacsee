CREATE TABLE [dbo].[subtestlimitsselect] (
  [acsUser] [char](50) NOT NULL,
  [Set_DateTime] [datetime] NULL,
  [Station_Name] [char](20) NULL,
  [SubTest_Name] [char](20) NOT NULL,
  [SAP_Model_Name] [char](20) NULL,
  [Limit_Type] [char](1) NOT NULL,
  [UL] [float] NULL,
  [LL] [float] NULL,
  [strLimit] [char](40) NULL,
  [flgLimit] [char](1) NULL,
  [Units] [char](10) NULL,
  [Description] [char](50) NULL,
  [Author] [char](25) NULL,
  [ACSEEMode] [int] NULL,
  [SPCParm] [char](1) NULL,
  [Hard_UL] [float] NULL,
  [Hard_LL] [float] NULL,
  [Limit_Date] [datetime] NULL,
  [ProductGroup_Mask] [int] NULL,
  [Limit_ID] [int] NULL,
  [Note_ID] [int] NULL,
  [OpportunitiesforFail] [int] NULL
)
ON [PRIMARY]
GO