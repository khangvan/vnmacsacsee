CREATE TABLE [dbo].[weeklytransfervalues] (
  [TRAN_ID] [int] IDENTITY,
  [PANLastTestlog] [int] NULL,
  [PAN_LastSubtestLog] [int] NULL,
  [WINLastTestlog] [int] NULL,
  [WINLastSubtestlog] [int] NULL,
  [PANLastLoad] [datetime] NULL,
  [WINLastLoad] [datetime] NULL,
  [BRAZILLastTestlog] [int] NULL,
  [BRAZIL_LastSubtestLog] [int] NULL,
  [BRAZILLastLoad] [datetime] NULL,
  CONSTRAINT [PK_weeklytransfervalues] PRIMARY KEY CLUSTERED ([TRAN_ID])
)
ON [PRIMARY]
GO