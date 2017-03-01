CREATE TABLE [dbo].[testvarchar] (
  [strid] [int] IDENTITY,
  [strvalue] [varchar](4000) NULL,
  CONSTRAINT [PK_testvarchar] PRIMARY KEY CLUSTERED ([strid])
)
ON [PRIMARY]
GO