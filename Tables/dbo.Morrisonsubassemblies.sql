CREATE TABLE [dbo].[Morrisonsubassemblies] (
  [id] [int] NOT NULL,
  [PSCSN] [char](20) NULL,
  [material] [char](20) NULL,
  [acsserial] [char](20) NULL,
  [scanned_serial] [char](20) NULL,
  [part_no_name] [char](20) NULL,
  [action_date] [datetime] NULL
)
ON [PRIMARY]
GO