CREATE TABLE [dbo].[FactoryGroup] (
  [FactoryGroup_Byte] [int] NOT NULL,
  [FactoryGroup_Name] [char](30) NULL,
  CONSTRAINT [PK_FactoryGroup] PRIMARY KEY NONCLUSTERED ([FactoryGroup_Byte]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO