CREATE TABLE [dbo].[NACS_SubTestLimits] (
  [Step_Name] [char](20) NOT NULL,
  [Station_Name] [char](20) NOT NULL,
  [SubTest_Name] [char](20) NOT NULL,
  [SAP_Model_Name] [char](20) NOT NULL,
  [Step_ID] [int] NOT NULL,
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
  CONSTRAINT [PK_NACS_SubTestLimits] PRIMARY KEY CLUSTERED ([Step_Name], [Station_Name], [SubTest_Name], [SAP_Model_Name], [ACSEEMode])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NACS_SubTestLimits] WITH NOCHECK
  ADD CONSTRAINT [FK_NACS_SubTestLimits_NACS_TestSteps] FOREIGN KEY ([Step_ID]) REFERENCES [dbo].[NACS_TestSteps] ([STEP_ID])
GO