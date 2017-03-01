CREATE TABLE [dbo].[TM_RawTECData] (
  [TECREC_ID] [int] IDENTITY,
  [TEC_SerialCode] [char](20) NULL,
  [TEC_Model] [char](20) NULL,
  [TEC_Station] [char](20) NULL,
  [TEC_Date] [datetime] NULL,
  [TEC_Time] [datetime] NULL,
  [TEC_Details] [char](80) NULL,
  [TEC_Esito] [char](10) NULL,
  [TEC_ValueAcquired] [char](80) NULL,
  [TEC_Extra1] [char](80) NULL,
  [TEC_Extra2] [char](80) NULL,
  CONSTRAINT [PK_TM_RawTECData] PRIMARY KEY CLUSTERED ([TECREC_ID])
)
ON [PRIMARY]
GO