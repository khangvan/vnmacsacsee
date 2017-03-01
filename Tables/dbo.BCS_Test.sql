CREATE TABLE [dbo].[BCS_Test] (
  [TEST_ID] [int] IDENTITY,
  [TEST_Name] [varchar](150) NULL,
  [TEST_Description] [varchar](150) NULL,
  [TEST_Path] [varchar](150) NULL,
  [TEST_DLLName] [varchar](150) NULL,
  [TEST_NameSpace] [varchar](150) NULL,
  [TEST_TargetUI] [varchar](150) NULL,
  [TEST_TargetTestName] [varchar](150) NULL,
  [TEST_FullNameSpace] [varchar](150) NULL,
  [TEST_TestStationSteps] [varchar](150) NULL,
  CONSTRAINT [PK_BCS_Test] PRIMARY KEY CLUSTERED ([TEST_ID])
)
ON [PRIMARY]
GO