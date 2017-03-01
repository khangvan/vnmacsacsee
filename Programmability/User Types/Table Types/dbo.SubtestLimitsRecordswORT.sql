CREATE TYPE [dbo].[SubtestLimitsRecordswORT] AS TABLE (
  [STEP_ID] [int] NULL,
  [station_name] [char](50) NOT NULL,
  [STEP_Name] [char](30) NOT NULL,
  [subtest_name] [char](20) NOT NULL,
  [SAP_Model] [char](20) NOT NULL,
  [Limit_Type] [char](3) NOT NULL,
  [UL] [float] NULL,
  [LL] [float] NULL,
  [strLimit] [char](40) NULL,
  [flgLimit] [char](1) NULL,
  [Units] [char](10) NOT NULL,
  [Description] [char](50) NULL,
  [Author] [char](25) NOT NULL,
  [ACSEEMode] [int] NOT NULL,
  [SPCParm] [char](1) NOT NULL,
  [Hard_UL] [float] NULL,
  [Hard_LL] [float] NULL,
  [flgForFailure] [int] NULL,
  [flgForFirst] [int] NULL,
  [flgDoALways] [int] NULL,
  [flgDoInOrt] [int] NULL
)
GO