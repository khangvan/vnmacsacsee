﻿CREATE TABLE [dbo].[TRN_Backup_assemblies] (
  [ACS_Serial] [char](20) NOT NULL,
  [SAP_Model_No] [int] NOT NULL,
  [Start_Station] [int] NOT NULL,
  [Top_Model_Prfx] [char](5) NOT NULL CONSTRAINT [DF_TRN_Backup_assemblies_Top_Model_Prfx] DEFAULT ('NA'),
  [Start_Mfg] [datetime] NOT NULL,
  [PSC_Serial] [char](20) NULL CONSTRAINT [DF_TRN_Backup_assemblies_PSC_Serial] DEFAULT (null),
  [End_Mfg] [datetime] NULL CONSTRAINT [DF_TRN_Backup_assemblies_End_Mfg] DEFAULT (null),
  [Sales_Order] [char](10) NULL CONSTRAINT [DF_TRN_Backup_assemblies_Sales_Order] DEFAULT (null),
  [Line_Item] [char](6) NULL CONSTRAINT [DF_TRN_Backup_assemblies_Line_Item] DEFAULT (null),
  [Current_State] [char](1) NULL,
  [assem_ID] [int] NOT NULL
)
ON [PRIMARY]
GO