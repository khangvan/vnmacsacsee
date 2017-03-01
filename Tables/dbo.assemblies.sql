CREATE TABLE [dbo].[assemblies] (
  [ACS_Serial] [char](20) NOT NULL,
  [SAP_Model_No] [int] NOT NULL,
  [Start_Station] [int] NOT NULL,
  [Top_Model_Prfx] [char](5) NOT NULL CONSTRAINT [DF_assemblies_Top_Model_Prfx] DEFAULT ('NA'),
  [Start_Mfg] [datetime] NOT NULL,
  [PSC_Serial] [char](20) NULL CONSTRAINT [DF_assemblies_PSC_Serial] DEFAULT (null),
  [End_Mfg] [datetime] NULL CONSTRAINT [DF_assemblies_End_Mfg] DEFAULT (null),
  [Sales_Order] [char](10) NULL CONSTRAINT [DF_assemblies_Sales_Order] DEFAULT (null),
  [Line_Item] [char](6) NULL CONSTRAINT [DF_assemblies_Line_Item] DEFAULT (null),
  [Current_State] [char](1) NULL,
  [assem_ID] [int] IDENTITY (16275124, 1),
  CONSTRAINT [PK_assemblies] PRIMARY KEY NONCLUSTERED ([ACS_Serial]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO

CREATE UNIQUE CLUSTERED INDEX [assem_id]
  ON [dbo].[assemblies] ([assem_ID])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_ACS_Serial]
  ON [dbo].[assemblies] ([ACS_Serial])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_PSC_Serial]
  ON [dbo].[assemblies] ([PSC_Serial])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Start_Mfg]
  ON [dbo].[assemblies] ([Start_Mfg])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO

CREATE INDEX [IX_assemblies_SAP_Model_No]
  ON [dbo].[assemblies] ([SAP_Model_No])
  WITH (FILLFACTOR = 90)
  ON [PRIMARY]
GO