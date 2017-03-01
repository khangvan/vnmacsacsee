CREATE TABLE [dbo].[OriginCodes] (
  [OCD_ID] [int] IDENTITY,
  [OCD_cCode] [varchar](50) NULL,
  [OCD_Desc] [varchar](80) NULL,
  [OCD_Type] [int] NULL,
  [OCD_order] [int] NULL,
  CONSTRAINT [PK_OriginCodes] PRIMARY KEY CLUSTERED ([OCD_ID])
)
ON [PRIMARY]
GO