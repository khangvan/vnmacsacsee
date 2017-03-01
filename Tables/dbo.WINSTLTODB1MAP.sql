﻿CREATE TABLE [dbo].[WINSTLTODB1MAP] (
  [WTDSTL_ID] [int] IDENTITY,
  [WINSTL_ID] [int] NULL,
  [DB1STL_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_WINSTLTODB1MAP] PRIMARY KEY CLUSTERED ([WTDSTL_ID])
)
ON [PRIMARY]
GO