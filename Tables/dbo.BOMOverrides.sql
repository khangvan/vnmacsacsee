CREATE TABLE [dbo].[BOMOverrides] (
  [SAP_Model] [nchar](20) NOT NULL,
  [Part_Number] [nchar](20) NOT NULL,
  [New_Part_Number] [nchar](20) NOT NULL,
  [Quantity] [int] NOT NULL,
  [Experation_Date] [smalldatetime] NOT NULL,
  [Author] [char](25) NULL,
  [ACSEEMode] [int] NULL,
  [Part_Description] [nchar](50) NULL,
  [Status] [char](1) NULL,
  [STLL_ID] [int] IDENTITY,
  CONSTRAINT [PK_BOMOverrides] PRIMARY KEY CLUSTERED ([STLL_ID])
)
ON [PRIMARY]
GO