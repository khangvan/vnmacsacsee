CREATE TABLE [dbo].[FirstPass] (
  [ACS_Serial] [char](20) NOT NULL,
  [Station] [char](20) NOT NULL,
  [Test_ID] [char](50) NULL,
  [Pass_Fail] [char](2) NULL
)
ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [ACS_Serial_Index]
  ON [dbo].[FirstPass] ([ACS_Serial], [Station])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO