CREATE TABLE [dbo].[Products] (
  [SAP_Count] [int] NOT NULL,
  [SAP_Model_Name] [char](20) NULL,
  [Format_Name] [char](20) NULL CONSTRAINT [DF_Products_Format_Name] DEFAULT (null),
  [Status] [char](1) NULL CONSTRAINT [DF_Products_Status] DEFAULT ('A'),
  CONSTRAINT [PK_Products] PRIMARY KEY CLUSTERED ([SAP_Count]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO