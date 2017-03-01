CREATE TABLE [dbo].[OverPackBox] (
  [OverPackBox_ID] [int] IDENTITY,
  [OverPackBox_Location] [char](30) NULL,
  [OverPackBox_ProductFamily] [char](30) NULL,
  [OverPackBox_HandlingUnit] [char](30) NULL,
  [OverPackBox_ItemDescription] [char](80) NULL,
  [OverPackBox_Units] [char](10) NULL,
  [OverPackBox_Length] [real] NULL,
  [OverPackBox_Width] [real] NULL,
  [OverPackBox_Height] [real] NULL,
  CONSTRAINT [PK_OverPackBox] PRIMARY KEY CLUSTERED ([OverPackBox_ID])
)
ON [PRIMARY]
GO