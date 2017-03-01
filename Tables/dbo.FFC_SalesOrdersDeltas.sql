﻿CREATE TABLE [dbo].[FFC_SalesOrdersDeltas] (
  [SO_ID] [int] NOT NULL,
  [SO_DIFF_Date] [datetime] NULL,
  [SO_OLD_SalesOrder] [varchar](50) NULL,
  [SO_OLD_SalesItem] [int] NULL,
  [SO_OLD_CustMatnr] [varchar](50) NULL,
  [SO_OLD_SerialProfile] [varchar](50) NULL,
  [SO_OLD_RequestDate] [datetime] NULL,
  [SO_OLD_ShipCond] [varchar](50) NULL,
  [SO_OLD_ShipCondType] [varchar](50) NULL,
  [SO_OLD_SoldTo] [varchar](50) NULL,
  [SO_OLD_INCOTERMS1] [varchar](50) NULL,
  [SO_OLD_INCOTERMS2] [varchar](50) NULL,
  [SO_OLD_SDPYMNTTERMS] [varchar](50) NULL,
  [SO_OLD_CUSTOMERPO] [varchar](50) NULL,
  [SO_OLD_FREIGHTTERMS] [varchar](50) NULL,
  [SO_OLD_FREIGHTTERMSTXT] [varchar](50) NULL,
  [SO_OLD_DELIVERYBLK] [varchar](50) NULL,
  [SO_OLD_DELIVERYBLKTXT] [varchar](50) NULL,
  [SO_OLD_SHIPTO] [varchar](50) NULL,
  [SO_OLD_CARRIER] [varchar](50) NULL,
  [SO_OLD_ADRNAME1] [varchar](50) NULL,
  [SO_OLD_ADRNAME2] [varchar](50) NULL,
  [SO_OLD_ADRSTREET] [varchar](50) NULL,
  [SO_OLD_ADRPOSTALCODE] [varchar](50) NULL,
  [SO_OLD_ADRCITY] [varchar](50) NULL,
  [SO_OLD_ADRSTATE] [varchar](50) NULL,
  [SO_OLD_ADRCOUNTRY] [varchar](50) NULL,
  [SO_OLD_ADRFAX] [varchar](50) NULL,
  [SO_OLD_ADRTEL] [varchar](50) NULL,
  [SO_OLD_ADRCOUNTRYDESC] [varchar](50) NULL,
  [SO_OLD_PURCHASEORDER] [varchar](50) NULL,
  [SO_OLD_PURCHASEITEM] [real] NULL,
  [SO_OLD_MATERIAL] [varchar](50) NULL,
  [SO_OLD_QTY] [real] NULL,
  [SO_OLD_UOM] [varchar](50) NULL,
  [SO_OLD_MATDESCRIPTION] [varchar](50) NULL,
  [SO_OLD_PRDHA] [varchar](50) NULL,
  [SO_OLD_PRICE] [real] NULL,
  [SO_OLD_TOTALPRICE] [real] NULL,
  [SO_OLD_REVISIONLVL] [varchar](50) NULL,
  [SO_OLD_WAERS] [varchar](50) NULL,
  [SO_OLD_POPYMNTTERMS] [varchar](50) NULL,
  [SO_OLD_POPYMNTTERMSTXT] [varchar](50) NULL,
  [SO_OLD_DELIVERYDATE] [datetime] NULL,
  [SO_NEW_SalesOrder] [varchar](50) NULL,
  [SO_NEW_SalesItem] [int] NULL,
  [SO_NEW_CustMatnr] [varchar](50) NULL,
  [SO_NEW_SerialProfile] [varchar](50) NULL,
  [SO_NEW_RequestDate] [datetime] NULL,
  [SO_NEW_ShipCond] [varchar](50) NULL,
  [SO_NEW_ShipCondType] [varchar](50) NULL,
  [SO_NEW_SoldTo] [varchar](50) NULL,
  [SO_NEW_INCOTERMS1] [varchar](50) NULL,
  [SO_NEW_INCOTERMS2] [varchar](50) NULL,
  [SO_NEW_SDPYMNTTERMS] [varchar](50) NULL,
  [SO_NEW_CUSTOMERPO] [varchar](50) NULL,
  [SO_NEW_FREIGHTTERMS] [varchar](50) NULL,
  [SO_NEW_FREIGHTTERMSTXT] [varchar](50) NULL,
  [SO_NEW_DELIVERYBLK] [varchar](50) NULL,
  [SO_NEW_DELIVERYBLKTXT] [varchar](50) NULL,
  [SO_NEW_SHIPTO] [varchar](50) NULL,
  [SO_NEW_CARRIER] [varchar](50) NULL,
  [SO_NEW_ADRNAME1] [varchar](50) NULL,
  [SO_NEW_ADRNAME2] [varchar](50) NULL,
  [SO_NEW_ADRSTREET] [varchar](50) NULL,
  [SO_NEW_ADRPOSTALCODE] [varchar](50) NULL,
  [SO_NEW_ADRCITY] [varchar](50) NULL,
  [SO_NEW_ADRSTATE] [varchar](50) NULL,
  [SO_NEW_ADRCOUNTRY] [varchar](50) NULL,
  [SO_NEW_ADRFAX] [varchar](50) NULL,
  [SO_NEW_ADRTEL] [varchar](50) NULL,
  [SO_NEW_ADRCOUNTRYDESC] [varchar](50) NULL,
  [SO_NEW_PURCHASEORDER] [varchar](50) NULL,
  [SO_NEW_PURCHASEITEM] [real] NULL,
  [SO_NEW_MATERIAL] [varchar](50) NULL,
  [SO_NEW_QTY] [real] NULL,
  [SO_NEW_UOM] [varchar](50) NULL,
  [SO_NEW_MATDESCRIPTION] [varchar](50) NULL,
  [SO_NEW_PRDHA] [varchar](50) NULL,
  [SO_NEW_PRICE] [real] NULL,
  [SO_NEW_TOTALPRICE] [real] NULL,
  [SO_NEW_REVISIONLVL] [varchar](50) NULL,
  [SO_NEW_WAERS] [varchar](50) NULL,
  [SO_NEW_POPYMNTTERMS] [varchar](50) NULL,
  [SO_NEW_POPYMNTTERMSTXT] [varchar](50) NULL,
  [SO_NEW_DELIVERYDATE] [datetime] NULL
)
ON [PRIMARY]
GO