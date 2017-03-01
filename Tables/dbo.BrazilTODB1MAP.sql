CREATE TABLE [dbo].[BrazilTODB1MAP] (
  [PTD_ID] [int] IDENTITY,
  [PAN_ID] [int] NULL,
  [DB1_ID] [int] NULL,
  [Transfer_Time] [datetime] NULL,
  CONSTRAINT [PK_BrazilTODB1MAP] PRIMARY KEY CLUSTERED ([PTD_ID])
)
ON [PRIMARY]
GO