CREATE TABLE [dbo].[FFC_EUG_PrintDirectories] (
  [Print_Dir_ID] [int] IDENTITY,
  [Print_Dir_Name] [varchar](50) NULL,
  [Print_Dir_Line] [varchar](50) NULL,
  [Print_Dir_Path] [varchar](50) NULL,
  [Print_Dir_Notes] [varchar](50) NULL,
  [FFC_SO_Vendor] [char](20) NULL,
  [FFC_SO_Plant] [char](10) NULL,
  CONSTRAINT [PK_FFC_EUG_PrintDirectories] PRIMARY KEY CLUSTERED ([Print_Dir_ID])
)
ON [PRIMARY]
GO