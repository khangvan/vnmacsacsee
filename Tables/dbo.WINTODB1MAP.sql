﻿CREATE TABLE [dbo].[WINTODB1MAP] (
  [WTD_ID] [int] IDENTITY,
  [WIN_ID] [int] NULL,
  [DB1_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_WINTODB1MAP] PRIMARY KEY CLUSTERED ([WTD_ID])
)
ON [PRIMARY]
GO