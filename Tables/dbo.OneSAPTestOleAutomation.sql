CREATE TABLE [dbo].[OneSAPTestOleAutomation] (
  [Test_ID] [int] IDENTITY,
  [TestValue] [char](30) NULL,
  [TestDateTime] [datetime] NULL,
  [TestTestValue] [int] NULL,
  [TestStringValue] [char](40) NULL,
  CONSTRAINT [PK_OneSAPTestOleAutomation] PRIMARY KEY CLUSTERED ([Test_ID])
)
ON [PRIMARY]
GO