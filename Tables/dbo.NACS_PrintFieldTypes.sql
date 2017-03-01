CREATE TABLE [dbo].[NACS_PrintFieldTypes] (
  [NACS_PrintFieldType_ID] [int] IDENTITY,
  [NACS_PrintFieldType] [varchar](50) NULL,
  CONSTRAINT [PK_NACS_PrintFIeldTypes] PRIMARY KEY CLUSTERED ([NACS_PrintFieldType_ID])
)
ON [PRIMARY]
GO