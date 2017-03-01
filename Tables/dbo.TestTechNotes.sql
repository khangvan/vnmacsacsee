CREATE TABLE [dbo].[TestTechNotes] (
  [TTN_ID] [int] IDENTITY,
  [TTN_Station_name] [char](20) NULL,
  [TTN_Note] [varchar](2000) NULL,
  [TTN_NoteDate] [datetime] NULL
)
ON [PRIMARY]
GO