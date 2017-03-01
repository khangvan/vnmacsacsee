CREATE TABLE [dbo].[NACS_PrintFields] (
  [NACS_Field_ID] [int] IDENTITY,
  [NACS_Field_Name] [varchar](50) NULL,
  [NACS_Field_Description] [varchar](80) NULL,
  [NACS_FieldType_ID] [int] NULL,
  CONSTRAINT [PK_NACS_PrintFields] PRIMARY KEY CLUSTERED ([NACS_Field_ID])
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[NACS_PrintFields]
  ADD CONSTRAINT [FK_NACS_PrintFields_NACS_PrintFIeldTypes] FOREIGN KEY ([NACS_FieldType_ID]) REFERENCES [dbo].[NACS_PrintFieldTypes] ([NACS_PrintFieldType_ID])
GO