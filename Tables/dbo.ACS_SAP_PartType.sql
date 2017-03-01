CREATE TABLE [dbo].[ACS_SAP_PartType] (
  [PartType] [char](5) NOT NULL,
  [Description] [char](50) NOT NULL,
  [flgTest] [bit] NOT NULL CONSTRAINT [DF_ACS_SAP_PartType_flgTest] DEFAULT (0),
  [flgACS] [bit] NOT NULL,
  [ID] [int] IDENTITY,
  CONSTRAINT [PK_ACS_SAP_PartType] PRIMARY KEY CLUSTERED ([PartType])
)
ON [PRIMARY]
GO