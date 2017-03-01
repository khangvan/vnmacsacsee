CREATE TABLE [dbo].[mac_range] (
  [id] [int] IDENTITY,
  [macgroup] [char](20) NULL,
  [range_min] [bigint] NULL,
  [range_max] [bigint] NULL,
  [next_mac] [bigint] NULL,
  [description] [char](80) NULL,
  CONSTRAINT [PK_mac_range] PRIMARY KEY CLUSTERED ([id]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO