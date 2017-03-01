CREATE TABLE [dbo].[NACS_PrinterFieldNames] (
  [PF_ID] [int] IDENTITY,
  [PF_Name] [varchar](50) NULL,
  [PF_MatrixName] [varchar](50) NULL,
  [PF_Modifier] [varchar](50) NULL,
  [PF_Type] [char](20) NULL,
  [PF_DefaultValue] [char](20) NULL,
  CONSTRAINT [PK_NACS_PrinterFieldNames] PRIMARY KEY CLUSTERED ([PF_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO