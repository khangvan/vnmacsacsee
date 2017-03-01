CREATE TABLE [dbo].[BlackBirdParameters] (
  [bbp_id] [int] IDENTITY,
  [bbp_acs_serial] [varchar](20) NOT NULL,
  [bbp_key] [varchar](50) NULL,
  [bbp_value] [varchar](50) NULL,
  [bbp_type] [varchar](50) NULL,
  CONSTRAINT [PK_BlackBirdParameters] PRIMARY KEY CLUSTERED ([bbp_id]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO