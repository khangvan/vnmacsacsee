CREATE TABLE [dbo].[FFC_Parts_Level] (
  [FFC_Model_ID] [int] IDENTITY,
  [SAP_Model] [nchar](20) NOT NULL,
  [Part_Number] [nchar](20) NOT NULL,
  [Rev] [nchar](3) NULL,
  [Description] [nchar](50) NULL,
  [BOM_Date_Time] [smalldatetime] NULL,
  [Station] [nchar](20) NULL,
  [Part_Type] [nchar](5) NULL,
  [ACSEEMode] [int] NULL,
  [Display_Option] [nchar](1) NULL,
  [Display_Order] [int] NULL,
  [FileMap] [nchar](20) NULL,
  [Qty] [int] NULL,
  [Lvl] [int] NULL,
  CONSTRAINT [PK_FFC_Parts_Level] PRIMARY KEY CLUSTERED ([FFC_Model_ID])
)
ON [PRIMARY]
GO