CREATE TABLE [dbo].[RJ_Connectors_VNM] (
  [RJ_ID] [int] IDENTITY,
  [RJ_Date] [datetime] NULL,
  [RJ_Test] [char](20) NULL,
  [RJ_Serial] [char](20) NULL,
  [RJ_Material] [char](30) NULL,
  [RJ_Equipment] [char](30) NULL,
  [RJ_Lsta_Ogg] [char](30) NULL,
  [RJ_Cogg] [int] NULL,
  [RJ_Numero_Posizioni] [int] NULL,
  [RJ_Order] [char](30) NULL,
  [RJ_Lsta_ogg2] [char](30) NULL,
  [RJ_Div] [char](10) NULL,
  [FG_Material] [char](30) NULL,
  [FG_Serial] [char](30) NULL,
  [PackingDateTime] [char](30) NULL,
  [BoxNumber] [char](20) NULL,
  [FulFillLocation] [char](10) NULL,
  CONSTRAINT [PK_RJ_Connectors_VNM] PRIMARY KEY CLUSTERED ([RJ_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO