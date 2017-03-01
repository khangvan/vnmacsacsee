CREATE TABLE [dbo].[LegacyORTMap] (
  [LOM_ID] [int] IDENTITY,
  [LOM_ACSSN] [char](20) NULL,
  [LOM_Assembly_ID] [int] NULL,
  [LOM_Serial] [char](20) NULL,
  [LOM_Model] [char](20) NULL,
  [LOM_Model_ID] [int] NULL,
  [LOM_Comments] [char](80) NULL,
  CONSTRAINT [PK_LegacyORTMap] PRIMARY KEY CLUSTERED ([LOM_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO