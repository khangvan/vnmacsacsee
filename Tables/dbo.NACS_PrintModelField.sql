CREATE TABLE [dbo].[NACS_PrintModelField] (
  [NACS_PrintModelField_ID] [int] IDENTITY,
  [NACS_PrintModel_ID] [int] NOT NULL,
  [NACS_PrintField_ID] [int] NOT NULL,
  [NACS_Culture_ID] [int] NOT NULL,
  [NACS_PrintValue] [varchar](80) NULL,
  [NACS_PrintImage] [image] NULL,
  CONSTRAINT [PK_NACS_PrintModelField] PRIMARY KEY CLUSTERED ([NACS_PrintModelField_ID])
)
ON [PRIMARY]
TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[NACS_PrintModelField] WITH NOCHECK
  ADD CONSTRAINT [FK_NACS_PrintModelField_NACS_Cultures] FOREIGN KEY ([NACS_Culture_ID]) REFERENCES [dbo].[NACS_Cultures] ([NACS_Culture_ID])
GO

ALTER TABLE [dbo].[NACS_PrintModelField] WITH NOCHECK
  ADD CONSTRAINT [FK_NACS_PrintModelField_NACS_PrintFields] FOREIGN KEY ([NACS_PrintField_ID]) REFERENCES [dbo].[NACS_PrintFields] ([NACS_Field_ID])
GO

ALTER TABLE [dbo].[NACS_PrintModelField] WITH NOCHECK
  ADD CONSTRAINT [FK_NACS_PrintModelField_NACS_PrintModels] FOREIGN KEY ([NACS_PrintModel_ID]) REFERENCES [dbo].[NACS_PrintModels] ([NACS_PrintModel_ID])
GO