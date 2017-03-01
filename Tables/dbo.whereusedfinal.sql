CREATE TABLE [dbo].[whereusedfinal] (
  [row_id] [int] IDENTITY,
  [plant] [int] NULL,
  [part] [char](30) NULL,
  [intopart] [char](30) NULL,
  [station] [char](30) NULL,
  CONSTRAINT [PK_whereusedfinal] PRIMARY KEY CLUSTERED ([row_id])
)
ON [PRIMARY]
GO