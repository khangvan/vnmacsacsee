CREATE TABLE [dbo].[BOMOverridesMControl] (
  [ID] [int] IDENTITY,
  [ChangeType] [nchar](30) NULL,
  [SAP_Model] [nchar](30) NULL,
  [StationName] [nchar](50) NULL,
  [PartnumberOriginal] [nchar](30) NULL,
  [PartnumberChange] [nchar](30) NULL,
  [ValidFrom] [datetime] NULL,
  [ValidTo] [datetime] NULL
)
ON [PRIMARY]
GO