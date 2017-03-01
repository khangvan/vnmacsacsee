CREATE TABLE [dbo].[AssemblyParameters] (
  [ASP_ID] [int] IDENTITY,
  [ASP_Assem_ID] [int] NULL,
  [ASP_Key] [varchar](50) NULL,
  [ASP_Value] [varchar](50) NULL,
  [ASP_Type] [varchar](50) NULL,
  CONSTRAINT [PK_AssemblyParameters] PRIMARY KEY CLUSTERED ([ASP_ID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO