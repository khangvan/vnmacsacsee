CREATE TABLE [dbo].[LabelVars] (
  [SAP_Model] [char](20) NOT NULL,
  [Var_Name] [char](20) NOT NULL,
  [Var_Value] [char](60) NOT NULL
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IX_LabelVars]
  ON [dbo].[LabelVars] ([SAP_Model])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO