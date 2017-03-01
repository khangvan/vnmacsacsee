CREATE TABLE [dbo].[TFFC_KickerPrintFileLookup] (
  [TFFC_KPFL_ID] [int] IDENTITY,
  [TFFC_KPFL_Model] [char](20) NULL,
  [TFFC_KPFL_BomPartName] [char](20) NULL,
  CONSTRAINT [PK_TFFC_KickerPrintFileLookup] PRIMARY KEY CLUSTERED ([TFFC_KPFL_ID])
)
ON [PRIMARY]
GO