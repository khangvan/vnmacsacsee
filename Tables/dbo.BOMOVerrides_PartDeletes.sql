CREATE TABLE [dbo].[BOMOVerrides_PartDeletes] (
  [BOMP_ID] [int] IDENTITY,
  [BOMP_OverrideID] [int] NULL,
  [BOMP_Part] [char](20) NULL,
  [BOMP_Expiration] [datetime] NULL,
  [BOMP_PNotes] [varchar](50) NULL,
  [BOMP_PAuthor] [char](20) NULL,
  [BOMP_InsertDate] [datetime] NULL,
  CONSTRAINT [PK_BOMOVerrides_PartDeletes] PRIMARY KEY CLUSTERED ([BOMP_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BOMOVerrides_PartDeletes] WITH NOCHECK
  ADD CONSTRAINT [FK_BOMOVerrides_PartDeletes_BOMOverrides_Parts] FOREIGN KEY ([BOMP_OverrideID]) REFERENCES [dbo].[BOMOverrides_Parts] ([BOMO_ID])
GO