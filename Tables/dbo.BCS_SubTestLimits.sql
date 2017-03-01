CREATE TABLE [dbo].[BCS_SubTestLimits] (
  [STEP_ID] [int] NOT NULL,
  [Station_Name] [char](120) NOT NULL,
  [SubTest_Name] [char](120) NOT NULL,
  [SAP_Model_Name] [char](120) NOT NULL,
  [SAP_MODEL_ID] [int] NULL,
  [Limit_Type] [char](1) NOT NULL,
  [UL] [float] NULL,
  [LL] [float] NULL,
  [strLimit] [char](140) NULL,
  [flgLimit] [char](1) NULL,
  [Units] [char](110) NULL,
  [Description] [char](150) NULL,
  [Author] [char](125) NULL,
  [ACSEEMode] [int] NOT NULL,
  [SPCParm] [char](1) NULL,
  [Hard_UL] [float] NULL,
  [Hard_LL] [float] NULL,
  [Limit_Date] [datetime] NOT NULL,
  [ProductGroup_Mask] [int] NULL,
  [Limit_ID] [int] IDENTITY (4359, 1),
  [Note_ID] [int] NULL,
  [OpportunitiesforFail] [int] NULL,
  [flgForFailure] [int] NULL,
  [flgFirstOnly] [int] NULL,
  [DoAlways] [int] NULL,
  [SkipInOrt] [int] NULL,
  CONSTRAINT [PK_BCS_SubTestLimits] PRIMARY KEY CLUSTERED ([Station_Name], [SubTest_Name], [SAP_Model_Name])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCS_SubTestLimits]
  ADD CONSTRAINT [FK_BCS_SubTestLimits_BCS_Steps1] FOREIGN KEY ([STEP_ID]) REFERENCES [dbo].[BCS_Steps] ([STEP_ID]) ON DELETE CASCADE
GO