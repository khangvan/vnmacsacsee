CREATE TABLE [dbo].[WeekCtr] (
  [WeekCTR_ID] [int] IDENTITY,
  [WeekCTR_Year] [int] NULL,
  [WeekCTR_Week] [int] NULL,
  [WeekCTR_Counter] [int] NULL,
  CONSTRAINT [PK_WeekCtr] PRIMARY KEY CLUSTERED ([WeekCTR_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO