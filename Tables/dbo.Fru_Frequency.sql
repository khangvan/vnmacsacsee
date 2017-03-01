CREATE TABLE [dbo].[Fru_Frequency] (
  [FRU_FRQ_ID] [int] IDENTITY,
  [Fru_Fru_ID] [int] NULL,
  [Fru_Category] [varchar](50) NULL,
  [Fru_Type] [int] NULL,
  [Fru_Frequency] [int] NULL,
  [Fru_Order] [int] NULL,
  CONSTRAINT [PK_Fru_Frequency] PRIMARY KEY CLUSTERED ([FRU_FRQ_ID])
)
ON [PRIMARY]
GO