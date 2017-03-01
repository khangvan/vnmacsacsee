CREATE TABLE [dbo].[FFC_EUG_BOM_Level_Station] (
  [Station] [nchar](20) NOT NULL,
  [SAP_Model] [nchar](20) NOT NULL,
  [Part_Number] [nchar](20) NOT NULL,
  [Rev] [nchar](3) NULL,
  [Description] [nchar](50) NULL,
  [BOM_Date_Time] [smalldatetime] NULL,
  [ACSEEMode] [int] NULL,
  [Qnty] [int] NULL,
  [BOMLevel] [int] NULL,
  [Part_Type] [char](5) NULL
)
ON [PRIMARY]
GO