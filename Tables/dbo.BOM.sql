CREATE TABLE [dbo].[BOM] (
  [SAP_Model] [nchar](20) NOT NULL,
  [Part_Number] [nchar](20) NOT NULL,
  [Rev] [nchar](3) NULL,
  [Description] [nchar](50) NULL,
  [BOM_Date_Time] [smalldatetime] NULL,
  [ACSEEMode] [int] NULL
)
ON [PRIMARY]
GO

CREATE CLUSTERED INDEX [IDX_Part_Number]
  ON [dbo].[BOM] ([Part_Number])
  ON [PRIMARY]
GO