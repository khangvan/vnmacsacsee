CREATE TABLE [dbo].[SK_Serialization] (
  [SER_ID] [int] IDENTITY,
  [SER_Number] [int] NULL,
  [Ser_CurrentWeek] [int] NULL,
  [Ser_CurrentMonth] [int] NULL,
  [SER_Product] [char](10) NULL,
  [SER_Plant] [char](10) NULL,
  CONSTRAINT [PK_SK_Serialiaztion] PRIMARY KEY CLUSTERED ([SER_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO