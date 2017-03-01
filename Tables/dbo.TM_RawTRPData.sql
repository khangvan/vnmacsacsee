CREATE TABLE [dbo].[TM_RawTRPData] (
  [TRPREC_ID] [int] IDENTITY,
  [TRP_SerialCode] [char](20) NULL,
  [TRP_Model] [char](20) NULL,
  [TRP_Station] [char](20) NULL,
  [TRP_Date] [datetime] NULL,
  [TRP_Time] [datetime] NULL,
  [TRP_Details] [varchar](80) NULL,
  [TRP_Performaed] [varchar](80) NULL,
  [TRP_Esito] [varchar](80) NULL,
  [TRP_ValueAcquired] [varchar](80) NULL,
  [TRP_Extra1] [varchar](80) NULL,
  [TRP_intValue] [int] NULL,
  [TRP_floatValue] [real] NULL,
  [TRP_Units] [char](30) NULL,
  [TRP_Comment] [char](80) NULL,
  CONSTRAINT [PK_TM_RawTRPData] PRIMARY KEY CLUSTERED ([TRPREC_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO