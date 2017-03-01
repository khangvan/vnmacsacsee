CREATE TABLE [dbo].[NACS_Cultures] (
  [NACS_Culture_ID] [int] IDENTITY,
  [NACS_Culture] [varchar](50) NULL,
  CONSTRAINT [PK_NACS_Cultures] PRIMARY KEY CLUSTERED ([NACS_Culture_ID])
)
ON [PRIMARY]
GO