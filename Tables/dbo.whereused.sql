CREATE TABLE [dbo].[whereused] (
  [row_id] [int] IDENTITY,
  [plant] [int] NULL,
  [part] [char](30) NULL,
  [intopart] [char](30) NULL,
  [station] [char](30) NULL,
  CONSTRAINT [PK_whereused] PRIMARY KEY CLUSTERED ([row_id])
)
ON [PRIMARY]
GO