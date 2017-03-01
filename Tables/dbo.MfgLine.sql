CREATE TABLE [dbo].[MfgLine] (
  [MLN_MfgLine_ID] [int] NOT NULL,
  [MLN_Plant_ID] [int] NULL,
  [MLN_MfgLine] [char](50) NULL,
  [MLN_Location] [int] NULL,
  CONSTRAINT [PK_MfgLine] PRIMARY KEY CLUSTERED ([MLN_MfgLine_ID])
)
ON [PRIMARY]
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'PK', 'SCHEMA', N'dbo', 'TABLE', N'MfgLine', 'COLUMN', N'MLN_MfgLine_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'FK:SAP_Plant', 'SCHEMA', N'dbo', 'TABLE', N'MfgLine', 'COLUMN', N'MLN_Plant_ID'
GO

EXEC sys.sp_addextendedproperty N'MS_Description', N'Name', 'SCHEMA', N'dbo', 'TABLE', N'MfgLine', 'COLUMN', N'MLN_MfgLine'
GO