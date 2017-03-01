CREATE TABLE [dbo].[TFFC_KICKER_TABLE] (
  [TFFC_KICKER_ID] [int] IDENTITY,
  [TFFC_KICKER_Station] [char](20) NULL,
  [TFFC_KICKER_Model] [char](20) NULL,
  [TFFC_KICKER_Description] [char](80) NULL,
  [TFFC_KICKER_TestType] [char](20) NULL,
  [TFFC_KICKER_RunPath] [char](80) NULL,
  [TFFC_KICKER_DBPath] [char](80) NULL,
  [TFFC_KICKER_SerialPortConfig] [char](120) NULL,
  [TFFC_KICKER_BinarySerialPortConfig] [char](50) NULL,
  [TFFC_KICKER_QBUDDIES] [char](20) NULL,
  [TFFC_KICKER_TMParameters] [char](80) NULL,
  [TFFC_KICKER_TMCodice] [char](40) NULL,
  [TFFC_KICKER_Rework] [int] NULL,
  CONSTRAINT [PK_TFFC_KICKER_TABLE] PRIMARY KEY CLUSTERED ([TFFC_KICKER_ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_Kicker_Tbl_Kicker_ID_Model_Tst_RDX]
  ON [dbo].[TFFC_KICKER_TABLE] ([TFFC_KICKER_Model], [TFFC_KICKER_TestType])
  ON [PRIMARY]
GO