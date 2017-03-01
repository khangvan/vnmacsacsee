﻿CREATE TABLE [dbo].[FFC_BOMDeltas] (
  [BOMDIFF_ID] [int] NOT NULL,
  [BOM_DIFF_Generation_ID] [int] NULL,
  [BOMDIFF_Date] [datetime] NULL,
  [BOMDIFF_SO] [varchar](50) NULL,
  [BOMDIFF_PO] [varchar](50) NULL,
  [BOMDIFF_PackageID] [varchar](50) NULL,
  [BOM_DIFF_Type] [int] NULL,
  [BOM_ITEM_DIFF_Type] [int] NULL,
  [OLD_SAP_Model] [nchar](20) NULL,
  [OLD_Part_Number] [nchar](20) NULL,
  [OLD_Rev] [nchar](3) NULL,
  [OLD_Description] [nchar](50) NULL,
  [OLD_BOM_Date_Time] [smalldatetime] NULL,
  [OLD_Station] [nchar](20) NULL,
  [OLD_Part_Type] [nchar](5) NULL,
  [OLD_ACSEEMode] [int] NULL,
  [OLD_Display_Option] [nchar](1) NULL,
  [OLD_Display_Order] [int] NULL,
  [OLD_FileMap] [nchar](20) NULL,
  [OLD_Qty] [int] NULL,
  [OLD_Lvl] [int] NULL,
  [NEW_SAP_Model] [nchar](20) NULL,
  [NEW_Part_Number] [nchar](20) NULL,
  [NEW_Rev] [nchar](3) NULL,
  [NEW_Description] [nchar](50) NULL,
  [NEW_BOM_Date_Time] [smalldatetime] NULL,
  [NEW_Station] [nchar](20) NULL,
  [NEW_Part_Type] [nchar](5) NULL,
  [NEW_ACSEEMode] [int] NULL,
  [NEW_Display_Option] [nchar](1) NULL,
  [NEW_Display_Order] [int] NULL,
  [NEW_FileMap] [nchar](20) NULL,
  [NEW_Qty] [int] NULL,
  [NEW_Lvl] [int] NULL
)
ON [PRIMARY]
GO