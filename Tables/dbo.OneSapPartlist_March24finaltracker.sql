CREATE TABLE [dbo].[OneSapPartlist_March24finaltracker] (
  [onesappartlist_id] [int] IDENTITY,
  [onesappartlist_pl_id] [int] NULL,
  [onesappartlist_newpartname] [char](30) NULL,
  [onesappartlist_oldpartname] [char](30) NULL,
  [onesappartlist_station] [char](40) NULL,
  [onesappartlist_adddate] [datetime] NULL,
  CONSTRAINT [PK_OneSapPartlist_March24finaltracker] PRIMARY KEY CLUSTERED ([onesappartlist_id]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO