CREATE TABLE [dbo].[RJ_Test] (
  [RJ_ID] [int] NOT NULL,
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
  [FG_Serial] [char](30) NULL
)
ON [PRIMARY]
GO