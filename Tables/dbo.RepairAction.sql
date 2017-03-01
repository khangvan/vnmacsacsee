CREATE TABLE [dbo].[RepairAction] (
  [RAN_RepairAction_ID] [int] IDENTITY,
  [RAN_Description] [char](80) NULL,
  [RAN_cActCode] [varchar](50) NULL,
  [RAN_ActCode] [int] NULL,
  [RAN_Critical] [tinyint] NULL,
  [RAN_Type] [int] NULL,
  [RAN_Order] [int] NULL,
  CONSTRAINT [PK_RepairAction] PRIMARY KEY CLUSTERED ([RAN_RepairAction_ID])
)
ON [PRIMARY]
GO