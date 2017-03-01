CREATE TABLE [dbo].[FFC_Partlist] (
  [FFC_PartNo_ID] [int] IDENTITY,
  [Part_No] [int] NOT NULL,
  [Station] [int] NOT NULL,
  [Menu] [char](1) NULL CONSTRAINT [DF_FFC_Partlist_Menu] DEFAULT (null),
  [Automatic] [char](1) NULL CONSTRAINT [DF_FFC_Partlist_Automatic] DEFAULT (null),
  [Get_Serial] [char](5) NULL CONSTRAINT [DF_FFC_Partlist_Get_Serial] DEFAULT (null),
  [Disp_Order] [int] NOT NULL CONSTRAINT [DF_FFC_Partlist_Disp_Order] DEFAULT ('1'),
  [Fill_Quantity] [int] NOT NULL CONSTRAINT [DF_FFC_Partlist_Fill_Quantity] DEFAULT ('1'),
  [PL_ID] [int] NOT NULL,
  CONSTRAINT [PK_FFC_Partlist] PRIMARY KEY CLUSTERED ([FFC_PartNo_ID])
)
ON [PRIMARY]
GO