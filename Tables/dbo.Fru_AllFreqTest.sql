CREATE TABLE [dbo].[Fru_AllFreqTest] (
  [FALT_ID] [int] IDENTITY,
  [FALT_fruCode] [int] NULL,
  [FALT_cFruCode] [nvarchar](50) NULL,
  [FALT_Fru_ID] [int] NULL,
  [FALT_Description] [char](80) NULL,
  [FALT_Testname] [char](30) NULL,
  [FALT_Type] [int] NULL,
  [FALT_Frequency] [int] NULL,
  CONSTRAINT [PK_Fru_AllFreqTest] PRIMARY KEY CLUSTERED ([FALT_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO