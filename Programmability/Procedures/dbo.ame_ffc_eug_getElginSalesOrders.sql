﻿SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ffc_eug_getElginSalesOrders]
 AS

set nocount on

select
FFC_SO_ID, 
FFC_SO_SalesOrder as SALES_ORDER, 
FFC_SO_SalesItem as SALES_ITEM, 
FFC_SO_CustMatnr as CUS_MATNR, 
FFC_SO_SerialProfile as SERIAL_PROFILE, 
FFC_SO_RequestDate as REQUEST_DATE, 
FFC_SO_ShipCond as SHIP_COND, 
FFC_SO_ShipCondType as SHIP_COND_TXT, 
FFC_SO_SoldTo as SOLD_TO, 
FFC_SO_INCOTERMS1 as INCO_TERMS1, 
FFC_SO_INCOTERMS2 as INCO_TERMS2, 
FFC_SO_SDPYMNTTERMS as SD_PYMNT_TERMS, 
FFC_SO_CUSTOMERPO as CUSTOMER_PO, 
FFC_SO_FREIGHTTERMS as FREIGHT_TERMS, 
FFC_SO_FREIGHTTERMSTXT as FREIGHT_TERMS_TXT, 
FFC_SO_DELIVERYBLK as DELIVERY_BLK, 
FFC_SO_DELIVERYBLKTXT as DELIVERY_BLK_TXT, 
FFC_SO_SHIPTO as SHIP_TO, 
FFC_SO_CARRIER as CARRIER, 
FFC_SO_ADRNAME1 as ADR_NAME1, 
FFC_SO_ADRNAME2 as ADR_NAME2, 
FFC_SO_ADRSTREET as ADR_STREET, 
FFC_SO_ADRPOSTALCODE as ADR_POSTAL_CODE, 
FFC_SO_ADRCITY as ADR_CITY, 
FFC_SO_ADRSTATE as ADR_REGION, 
FFC_SO_ADRCOUNTRY as ADR_COUNTRY, 
FFC_SO_ADRFAX as ADR_FAX, 
FFC_SO_ADRTEL as ADR_TEL, 
FFC_SO_ADRCOUNTRYDESC as COUNTRY_DESCR, 
FFC_SO_PURCHASEORDER as PURCHASE_ORDER, 
FFC_SO_PURCHASEITEM as PURCHASE_ITEM, 
FFC_SO_MATERIAL as MATERIAL, 
FFC_SO_PRDHA as PROD_HIER, 
FFC_SO_QTY as QTY, 
FFC_SO_UOM as UOM, 
FFC_SO_MATDESCRIPTION as MAT_DESCRIPTION, 
FFC_SO_POPRICE as PO_PRICE, 
FFC_SO_TOTALPRICE as TOTAL_PRICE, 
FFC_SO_REVISIONLVL as REVISION_LVL, 
FFC_SO_WAERS as WAERS, 
FFC_SO_POPYMNTTERMS as PO_PYMNT_TERMS, 
FFC_SO_POPYMNTTERMSTXT as PO_PYMNT_TERMS_TXT, 
FFC_SO_DELIVERYDATE as DELIVERY_DATE, 
FFC_SO_Vendor as VENDOR, 
FFC_SO_Plant as PLANT
from ffc_eug_elginsalesorders
GO