CREATE TABLE [dbo].[OneSapPartTranslate] (
  [OneSapTranslate_ID] [int] IDENTITY,
  [OneSapOldPart] [char](30) NULL,
  [OneSapNewPart] [char](30) NULL,
  [OneSapNewPartDescription] [char](40) NULL,
  CONSTRAINT [PK_OneSapPartTranslate] PRIMARY KEY CLUSTERED ([OneSapTranslate_ID])
)
ON [PRIMARY]
GO