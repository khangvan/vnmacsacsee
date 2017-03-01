CREATE TABLE [dbo].[DropDownRepairMap] (
  [DDR_ID] [int] IDENTITY,
  [DDR_Fru_ID] [int] NULL,
  [DDR_RepairAction_ID] [int] NULL,
  CONSTRAINT [PK_DropDownRepairMap] PRIMARY KEY CLUSTERED ([DDR_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[DropDownRepairMap]
  ADD CONSTRAINT [FK_DropDownRepairMap_RepairAction] FOREIGN KEY ([DDR_RepairAction_ID]) REFERENCES [dbo].[RepairAction] ([RAN_RepairAction_ID])
GO

ALTER TABLE [dbo].[DropDownRepairMap] WITH NOCHECK
  ADD CONSTRAINT [FK_DropDownRepairMap_SAP_NewRepairFrus] FOREIGN KEY ([DDR_Fru_ID]) REFERENCES [dbo].[SAP_NewRepairFrus] ([RFU_Fru_ID])
GO