CREATE TABLE [dbo].[NACS_PrintFileLookup] (
  [PRF_ID] [int] IDENTITY,
  [PRF_BomPartName] [char](20) NULL,
  [PRF_Station] [char](20) NULL,
  [PRF_ProductLine] [char](20) NULL,
  [PRF_PrintFileName] [char](20) NULL,
  [PRF_DoPrint] [char](3) NULL,
  [PRF_BulkPrintFile] [tinyint] NULL,
  [PRF_Ribbon] [varchar](50) NULL,
  [PRF_Paper] [varchar](50) NULL,
  [PRF_Machine] [varchar](50) NULL,
  [PRF_User] [varchar](50) NULL,
  [PRF_Variable1] [varchar](50) NULL,
  [PRF_PrinterName] [char](50) NULL,
  [PRF_DemandOrPrePrint] [int] NULL,
  CONSTRAINT [PK_NACS_PrintFileLookup] PRIMARY KEY CLUSTERED ([PRF_ID])
)
ON [PRIMARY]
GO