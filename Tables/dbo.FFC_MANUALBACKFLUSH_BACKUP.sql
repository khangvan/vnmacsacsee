﻿CREATE TABLE [dbo].[FFC_MANUALBACKFLUSH_BACKUP] (
  [MAN_backflush_ID] [int] NOT NULL,
  [Purchase_order] [nchar](50) NULL,
  [Purchase_Item] [int] NULL,
  [Material] [nchar](50) NULL,
  [Quantity] [int] NULL,
  [Serial_Number] [nchar](20) NULL
)
ON [PRIMARY]
GO