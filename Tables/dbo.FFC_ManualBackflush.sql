CREATE TABLE [dbo].[FFC_ManualBackflush] (
  [MAN_backflush_ID] [int] IDENTITY,
  [Purchase_order] [nchar](50) NULL,
  [Purchase_Item] [int] NULL,
  [Material] [nchar](50) NULL,
  [Quantity] [int] NULL,
  [Serial_Number] [nchar](20) NULL,
  CONSTRAINT [PK_FFC_ManualBackflush] PRIMARY KEY CLUSTERED ([MAN_backflush_ID])
)
ON [PRIMARY]
GO