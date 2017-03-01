CREATE TABLE [dbo].[SubAssemblyPathLookup] (
  [SubAssemPath_ID] [int] IDENTITY,
  [user_id] [char](50) NULL,
  [Lookup_Type] [int] NULL,
  [ACS_Serial] [char](20) NULL,
  [PSC_Serial] [char](20) NULL,
  [Model] [char](20) NULL,
  [ScannedSerial] [char](20) NULL,
  [ScannedModel] [char](20) NULL,
  [SubScannedSerial] [char](20) NULL,
  [SubScannedModel] [char](20) NULL,
  [Notes] [char](50) NULL,
  CONSTRAINT [PK_SubAssemblyPathLookup] PRIMARY KEY CLUSTERED ([SubAssemPath_ID])
)
ON [PRIMARY]
GO