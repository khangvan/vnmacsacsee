CREATE TABLE [dbo].[FRUBatchCounters] (
  [FRUBatch_ID] [int] IDENTITY,
  [FRUBatch_LocationPrefix] [char](2) NULL,
  [FRUBatch_Date] [datetime] NULL,
  [FRUBatch_Year] [char](10) NULL,
  [FRUBatch_Month] [char](10) NULL,
  [FRUBatch_Day] [char](10) NULL,
  [Key1] [char](20) NULL,
  [Key2] [char](20) NULL,
  [Key3] [char](20) NULL,
  [FRUBatch_Counter] [int] NULL,
  CONSTRAINT [PK_FRUBatchCounters] PRIMARY KEY CLUSTERED ([FRUBatch_ID])
)
ON [PRIMARY]
GO