CREATE TABLE [dbo].[ROHSpartmap] (
  [id] [int] IDENTITY,
  [old_part_no_name] [char](20) NULL,
  [new_part_no_name] [char](20) NULL,
  [Rev] [char](10) NULL,
  [DWG] [char](10) NULL,
  CONSTRAINT [PK_ROHSpartmap] PRIMARY KEY CLUSTERED ([id])
)
ON [PRIMARY]
GO