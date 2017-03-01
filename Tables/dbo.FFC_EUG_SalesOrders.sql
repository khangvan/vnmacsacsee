﻿CREATE TABLE [dbo].[FFC_EUG_SalesOrders] (
  [FFC_SO_ID] [int] IDENTITY,
  [FFC_SO_SalesOrder] [varchar](50) NULL,
  [FFC_SO_SalesItem] [int] NULL,
  [FFC_SO_CustMatnr] [varchar](50) NULL,
  [FFC_SO_SerialProfile] [varchar](50) NULL,
  [FFC_SO_RequestDate] [datetime] NULL,
  [FFC_SO_ShipCond] [varchar](50) NULL,
  [FFC_SO_ShipCondType] [varchar](50) NULL,
  [FFC_SO_SoldTo] [varchar](50) NULL,
  [FFC_SO_INCOTERMS1] [varchar](50) NULL,
  [FFC_SO_INCOTERMS2] [varchar](50) NULL,
  [FFC_SO_SDPYMNTTERMS] [varchar](50) NULL,
  [FFC_SO_CUSTOMERPO] [varchar](50) NULL,
  [FFC_SO_FREIGHTTERMS] [varchar](50) NULL,
  [FFC_SO_FREIGHTTERMSTXT] [varchar](50) NULL,
  [FFC_SO_DELIVERYBLK] [varchar](50) NULL,
  [FFC_SO_DELIVERYBLKTXT] [varchar](50) NULL,
  [FFC_SO_SHIPTO] [varchar](50) NULL,
  [FFC_SO_CARRIER] [varchar](50) NULL,
  [FFC_SO_ADRNAME1] [varchar](50) NULL,
  [FFC_SO_ADRNAME2] [varchar](50) NULL,
  [FFC_SO_ADRSTREET] [varchar](50) NULL,
  [FFC_SO_ADRPOSTALCODE] [varchar](50) NULL,
  [FFC_SO_ADRCITY] [varchar](50) NULL,
  [FFC_SO_ADRSTATE] [varchar](50) NULL,
  [FFC_SO_ADRCOUNTRY] [varchar](50) NULL,
  [FFC_SO_ADRFAX] [varchar](50) NULL,
  [FFC_SO_ADRTEL] [varchar](50) NULL,
  [FFC_SO_ADRCOUNTRYDESC] [varchar](50) NULL,
  [FFC_SO_PURCHASEORDER] [varchar](50) NULL,
  [FFC_SO_PURCHASEITEM] [real] NULL,
  [FFC_SO_MATERIAL] [varchar](50) NULL,
  [FFC_SO_PRDHA] [varchar](50) NULL,
  [FFC_SO_QTY] [real] NULL,
  [FFC_SO_UOM] [varchar](50) NULL,
  [FFC_SO_MATDESCRIPTION] [varchar](50) NULL,
  [FFC_SO_POPRICE] [real] NULL,
  [FFC_SO_TOTALPRICE] [real] NULL,
  [FFC_SO_REVISIONLVL] [varchar](50) NULL,
  [FFC_SO_WAERS] [varchar](50) NULL,
  [FFC_SO_POPYMNTTERMS] [varchar](50) NULL,
  [FFC_SO_POPYMNTTERMSTXT] [varchar](50) NULL,
  [FFC_SO_DELIVERYDATE] [datetime] NULL,
  [FFC_SO_Vendor] [char](20) NULL,
  [FFC_SO_Plant] [char](10) NULL,
  CONSTRAINT [PK_FFC_EUG_SalesOrders] PRIMARY KEY CLUSTERED ([FFC_SO_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO