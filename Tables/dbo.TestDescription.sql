CREATE TABLE [dbo].[TestDescription] (
  [TST_ID] [int] IDENTITY,
  [TST_Name] [char](30) NOT NULL,
  [Description] [varchar](50) NULL,
  CONSTRAINT [PK_TestDescription] PRIMARY KEY CLUSTERED ([TST_ID])
)
ON [PRIMARY]
GO