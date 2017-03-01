CREATE TABLE [dbo].[FFC_BOM_Level_Station] (
  [FFC_BOMLEVEL_ID] [int] IDENTITY,
  [Station] [nchar](20) NOT NULL,
  [SAP_Model] [nchar](20) NOT NULL,
  [Part_Number] [nchar](20) NOT NULL,
  [Rev] [nchar](3) NULL,
  [Description] [nchar](50) NULL,
  [BOM_Date_Time] [smalldatetime] NULL,
  [ACSEEMode] [int] NULL,
  [Qnty] [int] NULL,
  [BOMLevel] [int] NULL,
  CONSTRAINT [PK_FFC_BOM_Level_Station] PRIMARY KEY CLUSTERED ([FFC_BOMLEVEL_ID])
)
ON [PRIMARY]
GO