CREATE TABLE [dbo].[BOMOverrides_Log] (
  [BOMLOG_ID] [int] IDENTITY,
  [BOMP_ID] [int] NULL,
  [BOMP_OverrideID] [int] NULL,
  [BOMP_Part] [char](20) NULL,
  [BOMP_Expiration] [datetime] NULL,
  [BOMP_PNotes] [varchar](50) NULL,
  [BOMP_PAuthor] [char](20) NULL,
  [BOMP_InsertDate] [datetime] NULL,
  [BOMP_ActionDate] [datetime] NULL,
  [BOMP_Action] [char](20) NULL,
  [BOMP_ActionUser] [char](20) NULL,
  CONSTRAINT [PK_BOMOverrides_Log] PRIMARY KEY CLUSTERED ([BOMLOG_ID])
)
ON [PRIMARY]
GO