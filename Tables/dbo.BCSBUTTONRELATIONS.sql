﻿CREATE TABLE [dbo].[BCSBUTTONRELATIONS] (
  [BCS_BUTTONRELATION] [int] IDENTITY,
  [BCS_ButtonParent] [int] NULL,
  [BCS_ButtonChild] [int] NULL,
  [BCS_Step_ID] [int] NULL,
  [BCS_RelationType] [int] NULL,
  [BCS_RelationNote] [varchar](50) NULL
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[BCSBUTTONRELATIONS] WITH NOCHECK
  ADD CONSTRAINT [FK_BCSBUTTONRELATIONS_BCS_Buttons] FOREIGN KEY ([BCS_ButtonChild]) REFERENCES [dbo].[BCS_Buttons] ([BCS_Button_ID])
GO

ALTER TABLE [dbo].[BCSBUTTONRELATIONS]
  NOCHECK CONSTRAINT [FK_BCSBUTTONRELATIONS_BCS_Buttons]
GO

ALTER TABLE [dbo].[BCSBUTTONRELATIONS]
  ADD CONSTRAINT [FK_BCSBUTTONRELATIONS_BCS_Buttons1] FOREIGN KEY ([BCS_ButtonParent]) REFERENCES [dbo].[BCS_Buttons] ([BCS_Button_ID])
GO