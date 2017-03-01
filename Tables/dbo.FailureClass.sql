CREATE TABLE [dbo].[FailureClass] (
  [Failure_Class] [char](20) NOT NULL,
  [Class_Desc] [nvarchar](50) NULL,
  CONSTRAINT [PK_FailureClass] PRIMARY KEY NONCLUSTERED ([Failure_Class]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO