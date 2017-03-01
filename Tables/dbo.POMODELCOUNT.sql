﻿CREATE TABLE [dbo].[POMODELCOUNT] (
  [POMODELCOUNT_ID] [int] IDENTITY,
  [POMODELCOUNT_Station] [char](20) NULL,
  [POMODELCOUNT_PO] [char](20) NULL,
  [POMODELCOUNT_MODEL] [char](20) NULL,
  [POMODELCOUNT_Count] [int] NULL,
  [POMODELCOUNT_FirstDate] [datetime] NULL,
  [POMODELCOUNT_LastDate] [datetime] NULL,
  CONSTRAINT [PK_POMODELCOUNT] PRIMARY KEY CLUSTERED ([POMODELCOUNT_ID])
)
ON [PRIMARY]
GO