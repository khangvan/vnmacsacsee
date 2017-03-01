CREATE TABLE [dbo].[SerializationBackup] (
  [Prefix_Type] [char](3) NULL,
  [Prefix] [char](2) NULL,
  [Counter] [int] NULL,
  [Last_Event_Date] [datetime] NULL,
  [Imbedded_Date] [char](1) NULL
)
ON [PRIMARY]
GO