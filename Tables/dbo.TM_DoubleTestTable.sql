CREATE TABLE [dbo].[TM_DoubleTestTable] (
  [DT_ID] [int] IDENTITY NOT FOR REPLICATION,
  [DT_Model] [char](20) NULL,
  [DT_Station] [char](20) NULL,
  [DT_SubTest] [char](30) NULL,
  CONSTRAINT [PK_TM_DoubleTestTable] PRIMARY KEY CLUSTERED ([DT_ID])
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_DT_Model_RDX]
  ON [dbo].[TM_DoubleTestTable] ([DT_Model])
  ON [PRIMARY]
GO