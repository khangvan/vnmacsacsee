CREATE TABLE [dbo].[KrogerBT0909] (
  [ID] [int] IDENTITY,
  [ProdOrder] [nchar](30) NULL,
  [PSCSerial] [nchar](20) NULL,
  [ACSSerial] [nchar](20) NULL,
  [TopSAPModel] [nchar](20) NULL,
  [ScannedSerial] [nchar](20) NULL,
  [PartNoName] [nchar](30) NULL,
  CONSTRAINT [PK_KrogerBT0909] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO