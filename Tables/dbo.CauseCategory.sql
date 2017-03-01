CREATE TABLE [dbo].[CauseCategory] (
  [CAC_CauseCategory_ID] [int] IDENTITY,
  [CAC_Description] [varchar](80) NULL,
  [CAC_Code] [int] NULL,
  [CAC_cCode] [varchar](50) NULL,
  [CAC_Type] [int] NULL,
  [CAC_Order] [int] NULL,
  CONSTRAINT [PK_CauseCategory] PRIMARY KEY CLUSTERED ([CAC_CauseCategory_ID])
)
ON [PRIMARY]
GO