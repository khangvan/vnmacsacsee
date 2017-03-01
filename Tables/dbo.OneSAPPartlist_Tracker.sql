CREATE TABLE [dbo].[OneSAPPartlist_Tracker] (
  [onesappartlist_id] [int] IDENTITY,
  [onesappartlist_pl_id] [int] NULL,
  [onesappartlist_newpartname] [char](30) NULL,
  [onesappartlist_oldpartname] [char](30) NULL,
  [onesappartlist_station] [char](40) NULL,
  [onesappartlist_adddate] [datetime] NULL,
  CONSTRAINT [PK_OneSAPPartlist_Tracker] PRIMARY KEY CLUSTERED ([onesappartlist_id])
)
ON [PRIMARY]
GO