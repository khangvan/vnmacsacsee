CREATE TABLE [dbo].[BOMO_PartAdds] (
  [BOMA_ID] [int] NOT NULL,
  [BOMA_OverrideID] [int] NOT NULL,
  [BOMA_Part] [char](20) NULL,
  [BOMA_Expiration] [datetime] NULL,
  [BOMA_PNotes] [varchar](50) NULL,
  [BOMA_PAuthor] [char](20) NULL,
  CONSTRAINT [PK_BOMO_PartAdds] PRIMARY KEY CLUSTERED ([BOMA_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOMO_PartAdds] WITH NOCHECK
  ADD CONSTRAINT [FK_BOMO_PartAdds_BOMOverrides_Parts] FOREIGN KEY ([BOMA_OverrideID]) REFERENCES [dbo].[BOMOverrides_Parts] ([BOMO_ID])
GO