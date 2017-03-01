CREATE TABLE [dbo].[FFC_BackFlush_SendBack] (
  [FFC_BackFlush_ID] [int] IDENTITY,
  [FFC_BackFlush_PO] [nchar](50) NULL,
  [FFC_BackFlush_POItem] [int] NULL,
  [FFC_BackFlush_Material] [nchar](50) NULL,
  [FFC_BackFlush_MatDescription] [varchar](50) NULL,
  [FFC_BackFlush_Qty] [int] NULL,
  [FFC_BackFlush_TotalQty] [int] NULL,
  [FFC_BackFlush_SerialNo] [nchar](20) NULL,
  [FFC_BackFlush_Date] [datetime] NULL,
  [FFC_BackFlush_Vendor] [char](20) NULL,
  [FFC_BackFlush_Plant] [char](10) NULL,
  [FFC_BackFlush_Locked] [tinyint] NULL,
  [FFC_BackFlush_LockDate] [datetime] NULL,
  [FFC_BackFlush_CountQty] [int] NULL,
  [FFC_BackFlush_SentAssembly] [int] NULL,
  [FFC_BackFlush_SentTestLog] [int] NULL,
  [FFC_BackFLush_SentSubtestLog] [int] NULL
)
ON [PRIMARY]
GO