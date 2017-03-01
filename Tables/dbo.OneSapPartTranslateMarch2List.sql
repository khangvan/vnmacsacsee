CREATE TABLE [dbo].[OneSapPartTranslateMarch2List] (
  [OneSapTranslate_ID] [int] IDENTITY,
  [OneSapOldPart] [char](30) NULL,
  [OneSapNewPart] [char](30) NULL,
  [OneSapNewPartDescription] [char](40) NULL,
  CONSTRAINT [PK_OneSapPartTranslateMarch2List] PRIMARY KEY CLUSTERED ([OneSapTranslate_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO