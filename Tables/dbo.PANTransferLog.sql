CREATE TABLE [dbo].[PANTransferLog] (
  [JOB_Log_ID] [int] IDENTITY,
  [JOB_DateTime] [datetime] NULL,
  [JOB_Step] [varchar](80) NULL,
  [JOB_Status] [char](20) NULL,
  [JOB_StepNotes] [char](80) NULL,
  [JOB_Parameter1] [varchar](50) NULL,
  [JOB_Parameter2] [varchar](50) NULL,
  [JOB_Parameter3] [varchar](50) NULL,
  [JOB_Completion] [datetime] NULL,
  [JOB_Source] [varchar](150) NULL,
  [JOB_Documentation] [varchar](255) NULL,
  [JOB_Owner] [char](40) NULL,
  [JOB_FileDate] [datetime] NULL,
  [JOB_StrFileDate] [char](80) NULL,
  [JOB_StrFile] [char](80) NULL,
  CONSTRAINT [PK_PANTransferLog] PRIMARY KEY CLUSTERED ([JOB_Log_ID])
)
ON [PRIMARY]
GO