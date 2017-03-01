CREATE TABLE [dbo].[backuppartlist] (
  [Part_No] [int] NOT NULL,
  [Station] [int] NOT NULL,
  [Menu] [char](1) NULL CONSTRAINT [DF_backuppartlist_Menu] DEFAULT (null),
  [Automatic] [char](1) NULL CONSTRAINT [DF_backuppartlist_Automatic] DEFAULT (null),
  [Get_Serial] [char](5) NULL CONSTRAINT [DF_backuppartlist_Get_Serial] DEFAULT (null),
  [Disp_Order] [int] NOT NULL CONSTRAINT [DF_backuppartlist_Disp_Order] DEFAULT ('1'),
  [Fill_Quantity] [int] NOT NULL CONSTRAINT [DF_backuppartlist_Fill_Quantity] DEFAULT ('1'),
  [PL_ID] [int] NOT NULL
)
ON [PRIMARY]
GO