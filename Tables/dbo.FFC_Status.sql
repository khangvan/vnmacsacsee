CREATE TABLE [dbo].[FFC_Status] (
  [FFC_Status_ID] [int] IDENTITY,
  [FFC_StatusName] [varchar](50) NULL,
  [FFC_StatusDescription] [varchar](50) NULL,
  CONSTRAINT [PK_FFC_Status] PRIMARY KEY CLUSTERED ([FFC_Status_ID])
)
ON [PRIMARY]
GO