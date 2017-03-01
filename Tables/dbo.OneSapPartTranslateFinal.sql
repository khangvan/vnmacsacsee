CREATE TABLE [dbo].[OneSapPartTranslateFinal] (
  [OneSapTranslate_ID] [int] IDENTITY,
  [OneSapOldPart] [char](30) NULL,
  [OneSapNewPart] [char](30) NULL,
  [OneSapNewPartDescription] [char](40) NULL,
  CONSTRAINT [PK_OneSapPartTranslateFinal] PRIMARY KEY CLUSTERED ([OneSapTranslate_ID])
)
ON [PRIMARY]
GO