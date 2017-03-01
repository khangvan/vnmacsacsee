﻿CREATE TABLE [dbo].[BCSSTEPRELATIONS] (
  [STEPRELATE_id] [int] IDENTITY,
  [STEPRELCHILD_id] [int] NULL,
  [STEPRELDISPLAY] [int] NULL,
  [STEPRELOTHER] [nchar](10) NULL,
  CONSTRAINT [PK_BCSSTEPRELATIONS] PRIMARY KEY CLUSTERED ([STEPRELATE_id])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCSSTEPRELATIONS]
  ADD CONSTRAINT [FK_BCSSTEPRELATIONS_BCS_Steps] FOREIGN KEY ([STEPRELCHILD_id]) REFERENCES [dbo].[BCS_Steps] ([STEP_ID])
GO