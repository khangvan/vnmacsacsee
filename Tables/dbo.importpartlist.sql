CREATE TABLE [dbo].[importpartlist] (
  [partlist_id] [int] IDENTITY,
  [station_name] [char](30) NULL,
  [part_no_name] [char](20) NULL,
  [menu] [char](1) NULL,
  [automatic] [char](1) NULL,
  [get_serial] [char](5) NULL,
  [disp_order] [int] NULL,
  [fill_quantity] [int] NULL,
  CONSTRAINT [PK_importpartlist] PRIMARY KEY CLUSTERED ([partlist_id]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO