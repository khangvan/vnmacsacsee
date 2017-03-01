CREATE TABLE [dbo].[TransferValues] (
  [TRAN_ID] [int] IDENTITY,
  [PANLastTestlog] [int] NULL,
  [PAN_LastSubtestLog] [int] NULL,
  [WINLastTestlog] [int] NULL,
  [WINLastSubtestlog] [int] NULL,
  [PANLastLoad] [datetime] NULL,
  [WINLastLoad] [datetime] NULL,
  CONSTRAINT [PK_TransferValues] PRIMARY KEY CLUSTERED ([TRAN_ID])
)
ON [PRIMARY]
GO