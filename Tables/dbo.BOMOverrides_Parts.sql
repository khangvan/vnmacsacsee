CREATE TABLE [dbo].[BOMOverrides_Parts] (
  [BOMO_ID] [int] IDENTITY,
  [BOMO_Station] [char](20) NULL,
  [BOMO_Part] [char](20) NULL,
  [BOMO_Model] [char](20) NULL,
  [BOMO_Chars] [int] NULL,
  [BOMO_Notes] [varchar](80) NULL,
  [BOMO_User] [char](50) NULL,
  [TimeStart] [datetime] NULL,
  [TimeStop] [datetime] NULL,
  [BOMO_PartNew] [char](20) NULL,
  CONSTRAINT [PK_BOMOverrides_Models] PRIMARY KEY CLUSTERED ([BOMO_ID])
)
ON [PRIMARY]
GO