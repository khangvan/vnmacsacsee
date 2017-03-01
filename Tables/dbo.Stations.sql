CREATE TABLE [dbo].[Stations] (
  [Station_Count] [int] NOT NULL,
  [Station_Name] [char](20) NOT NULL,
  [Description] [nchar](40) NULL CONSTRAINT [DF_Stations_Description] DEFAULT (null),
  [ACS_Serial_ID] [char](2) NULL CONSTRAINT [DF_Stations_Serial_ID] DEFAULT (null),
  [Gen_PSC_Serial] [char](1) NULL CONSTRAINT [DF_Stations_Gen_PSC_Serial] DEFAULT (null),
  [Print_Asm_Label] [char](1) NULL CONSTRAINT [DF_Stations_Asm_Label_Printer] DEFAULT (null),
  [Print_Unit_Label] [char](1) NULL CONSTRAINT [DF_Stations_Unit_Label_Printer] DEFAULT (null),
  [Print_Carton_Label] [char](1) NULL CONSTRAINT [DF_Stations_Reg_Label_Printer] DEFAULT (null),
  [Print_Extra_label] [char](1) NULL CONSTRAINT [DF_Stations_Carton_Label_Printer] DEFAULT (null),
  [Allow_Overrides] [char](1) NULL CONSTRAINT [DF_Stations_Allow_Overrides] DEFAULT (null),
  [Finish_Assembly] [char](1) NULL CONSTRAINT [DF_Stations_SubAss_Finish] DEFAULT (null),
  [Perform_Test] [char](1) NULL CONSTRAINT [DF_Stations_Test_Station] DEFAULT (null),
  [Assign_Sales_Order] [char](1) NULL CONSTRAINT [DF_Stations_Assignment] DEFAULT (null),
  [Backflush] [char](1) NULL CONSTRAINT [DF_Stations_Backflush] DEFAULT (null),
  [Status] [char](1) NOT NULL CONSTRAINT [DF_Stations_Status] DEFAULT ('A'),
  [Machine_Name] [char](30) NULL,
  [FactoryGroup_Mask] [int] NULL,
  [ProductGroup_Mask] [int] NULL,
  [Order_Value] [int] NULL,
  [Thin_Client] [char](1) NULL,
  [Station_Type] [char](3) NULL,
  [Waterfall_Server_Machine_Name] [char](20) NULL,
  [Application_Server_Machine_Name] [char](20) NULL,
  [Business_Server_Machine_Name] [char](20) NULL,
  [STN_MfgLine_ID] [int] NULL CONSTRAINT [DF_Stations_STN_MfgLine_ID] DEFAULT (1000),
  [SPCEnabled] [char](1) NULL,
  [SAPLocationIndex] [int] NULL,
  [SAPLocationName] [char](20) NULL,
  [TestName] [char](50) NULL,
  [BOMEndPoint] [char](255) NULL,
  [BOMWerks] [char](50) NULL,
  [EnableBatchMode] [int] NULL,
  [DefaultToBatchMode] [int] NULL,
  CONSTRAINT [PK_Stations] PRIMARY KEY NONCLUSTERED ([Station_Count]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO

CREATE INDEX [IDX_ACS_Serial_ID]
  ON [dbo].[Stations] ([ACS_Serial_ID])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Gen_PSC_Serial]
  ON [dbo].[Stations] ([Gen_PSC_Serial])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO

CREATE INDEX [IDX_Station_Name]
  ON [dbo].[Stations] ([Station_Name])
  WITH (FILLFACTOR = 80)
  ON [PRIMARY]
GO