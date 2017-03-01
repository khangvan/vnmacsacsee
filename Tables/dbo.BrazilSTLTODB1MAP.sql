﻿CREATE TABLE [dbo].[BrazilSTLTODB1MAP] (
  [PTDSTL_ID] [int] IDENTITY,
  [PANSTL_ID] [int] NULL,
  [DB1STL_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_BrazilSTLTODB1MAP] PRIMARY KEY CLUSTERED ([PTDSTL_ID])
)
ON [PRIMARY]
GO