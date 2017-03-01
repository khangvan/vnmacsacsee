CREATE TABLE [dbo].[Tests] (
  [TST_Test_ID] [int] IDENTITY,
  [TST_TestName] [char](30) NULL,
  [TST_fInFP] [tinyint] NULL,
  [TST_fInORT] [tinyint] NULL,
  [TST_fInPCB] [tinyint] NULL,
  [TST_fInCum] [tinyint] NULL,
  [TST_fPerformTest] [tinyint] NULL,
  [STN_Name] [char](20) NULL,
  [STN_Description] [varchar](50) NULL,
  CONSTRAINT [PK_Tests] PRIMARY KEY CLUSTERED ([TST_Test_ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_TST_fInPCB_RDX]
  ON [dbo].[Tests] ([STN_Name], [TST_fInPCB])
  ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'Tests', 'COLUMN', N'TST_Test_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'name', 'SCHEMA', N'dbo', 'TABLE', N'Tests', 'COLUMN', N'TST_TestName'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'flag if included in FP yields', 'SCHEMA', N'dbo', 'TABLE', N'Tests', 'COLUMN', N'TST_fInFP'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'flag if included in ORT yields', 'SCHEMA', N'dbo', 'TABLE', N'Tests', 'COLUMN', N'TST_fInORT'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'flag if included in PCB yields', 'SCHEMA', N'dbo', 'TABLE', N'Tests', 'COLUMN', N'TST_fInPCB'
GO