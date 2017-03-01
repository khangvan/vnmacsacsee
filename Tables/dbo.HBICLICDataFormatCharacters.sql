CREATE TABLE [dbo].[HBICLICDataFormatCharacters] (
  [ID] [int] IDENTITY,
  [HBICID] [int] NOT NULL,
  [Character] [char](1) NOT NULL,
  [Note] [char](50) NULL,
  CONSTRAINT [PK_HBICLICDataFormatCharacters] PRIMARY KEY CLUSTERED ([ID])
)
ON [PRIMARY]
GO