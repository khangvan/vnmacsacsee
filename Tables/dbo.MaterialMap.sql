CREATE TABLE [dbo].[MaterialMap] (
  [Top_Model_Prfx] [char](5) NOT NULL,
  [Digits] [char](5) NOT NULL,
  CONSTRAINT [PK_MaterialMap] PRIMARY KEY NONCLUSTERED ([Top_Model_Prfx], [Digits]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO