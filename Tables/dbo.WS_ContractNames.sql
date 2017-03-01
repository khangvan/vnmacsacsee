CREATE TABLE [dbo].[WS_ContractNames] (
  [WS_Contract_ID] [int] IDENTITY,
  [WS_Contract_SymbolicName] [char](50) NULL,
  [WS_Contract_RealName] [char](50) NULL,
  [WS_Contract_Note] [char](100) NULL,
  CONSTRAINT [PK_WS_ContractNames] PRIMARY KEY CLUSTERED ([WS_Contract_ID])
)
ON [PRIMARY]
GO