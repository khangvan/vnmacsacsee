CREATE TABLE [dbo].[BCSBACKUP_BCSBUTTONRELATIONS] (
  [BCS_BUTTONRELATION] [int] NOT NULL,
  [BCS_ButtonParent] [int] NULL,
  [BCS_ButtonChild] [int] NULL,
  [BCS_Step_ID] [int] NULL,
  [BCS_RelationType] [int] NULL,
  [BCS_RelationNote] [varchar](50) NULL
)
ON [PRIMARY]
GO