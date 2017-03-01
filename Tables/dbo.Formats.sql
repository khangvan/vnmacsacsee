CREATE TABLE [dbo].[Formats] (
  [SAP_Model] [char](20) NOT NULL,
  [Label_Format_Prefix] [char](20) NOT NULL,
  [Type_Byte] [int] NOT NULL,
  CONSTRAINT [PK_Formats] PRIMARY KEY CLUSTERED ([SAP_Model]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO