CREATE TABLE [dbo].[OneSAPMarch24FinalTranslateList] (
  [OneSapTranslate_ID] [int] IDENTITY,
  [OneSapOldPart] [varchar](80) NULL,
  [OneSapNewPart] [varchar](80) NULL,
  [Partytype] [varchar](80) NULL,
  [YesNo] [varchar](80) NULL,
  [OneSapCorrectedNewPart] [char](80) NULL,
  [OneSapNewPartDescription] [char](40) NULL,
  CONSTRAINT [PK_OneSAPMarch24FinalTranslateList] PRIMARY KEY CLUSTERED ([OneSapTranslate_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO