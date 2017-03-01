CREATE TABLE [dbo].[tempPFYield] (
  [Test_Date_Time] [datetime] NULL,
  [DateRun] [date] NULL,
  [HourRun] [int] NULL,
  [ShiftRun] [int] NOT NULL,
  [Station] [char](20) NULL,
  [SAP_Model] [char](20) NULL,
  [ACS_Serial] [char](20) NOT NULL,
  [FP] [int] NOT NULL,
  [RTP] [int] NULL,
  [F] [int] NULL
)
ON [PRIMARY]
GO