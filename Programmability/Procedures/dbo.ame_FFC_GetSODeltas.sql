SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetSODeltas]
 AS
declare @max_delta_id int
declare @delta_date datetime

declare @newso nchar(50)
declare @newsalesitem nchar(50)
declare @newcustmatnr nchar(50)
declare @newserialprofile  nchar(50)
declare @newrequestdate datetime
declare @newshipcond  nchar(50)
declare @newshipcondtype  nchar(50)
declare @newsoldto  nchar(50)
declare @newincoterms1  nchar(50)
declare @newincoterms2  nchar(50)
declare @newsdpymntterms nchar(50)
declare @newcustomerpo  nchar(50)
declare @newfreightterms  nchar(50)
declare @newfreighttermstxt  nchar(50)
declare @newdeliveryblk  nchar(50)
declare @newdeliveryblktxt  nchar(50)
declare @newshipto  nchar(50)
declare @newcarrier  nchar(50)
declare @newadrname1  nchar(50)
declare @newadrname2  nchar(50)
declare @newadrstreet  nchar(50)
declare @newadrpostalcode  nchar(50)
declare @newadrcity  nchar(50)
declare @newadrstate  nchar(50)
declare @newadrcountry  nchar(50)
declare @newadrfax  nchar(50)
declare @newadrtel  nchar(50)
declare @newadrcountrydesc  nchar(50)
declare @newpurchaseorder  nchar(50)
declare @newpurchaseitem real
declare @newmaterial  nchar(50)
declare @newqty real
declare @newuom  nchar(50)
declare @newmatdescription  nchar(50)
declare @newprdha  nchar(50)
declare @newprice  real
declare @newtotalprice real
declare @newrevisionlvl  nchar(50)
declare @newwaers  nchar(50)
declare @newpopymntterms  nchar(50)
declare @newpopymnttermstxt  nchar(50)
declare @newdeliverydate datetime





declare @oldso nchar(50)
declare @oldsalesitem nchar(50)
declare @oldcustmatnr nchar(50)
declare @oldserialprofile  nchar(50)
declare @oldrequestdate datetime
declare @oldshipcond  nchar(50)
declare @oldshipcondtype  nchar(50)
declare @oldsoldto  nchar(50)
declare @oldincoterms1  nchar(50)
declare @oldincoterms2  nchar(50)
declare @oldcustomerpo  nchar(50)
declare @oldfreightterms  nchar(50)
declare @oldfreighttermstxt  nchar(50)
declare @olddeliveryblk  nchar(50)
declare @olddeliveryblktxt  nchar(50)
declare @oldshipto  nchar(50)
declare @oldcarrier  nchar(50)
declare @oldadrname1  nchar(50)
declare @oldadrname2  nchar(50)
declare @oldadrstreet  nchar(50)
declare @oldadrpostalcode  nchar(50)
declare @oldadrcity  nchar(50)
declare @oldadrstate  nchar(50)
declare @oldadrcountry  nchar(50)
declare @oldadrfax  nchar(50)
declare @oldadrtel  nchar(50)
declare @oldadrcountrydesc  nchar(50)
declare @oldpurchaseorder  nchar(50)
declare @oldpurchaseitem real
declare @oldmaterial  nchar(50)
declare @oldqty real
declare @olduom  nchar(50)
declare @oldmatdescription  nchar(50)
declare @oldprdha  nchar(50)
declare @oldprice  real
declare @oldtotalprice real
declare @oldrevisionlvl  nchar(50)
declare @oldwaers  nchar(50)
declare @oldpopymntterms  nchar(50)
declare @oldpopymnttermstxt  nchar(50)
declare @olddeliverydate datetime







declare @newpartnumber nchar(20)
declare @newrev nchar(3)
declare @newdescription nchar(50)
declare @newstation nchar(20)
declare @newparttype nchar(5)
declare @newacseemode int
declare @newdisplayoption nchar(1)
declare @newdisplayorder int
declare @newfilemap nchar(20)
--declare @newqty int
declare @newlvl int

--declare @oldso nchar(20)
declare @oldpartnumber nchar(20)
declare @oldrev nchar(3)
declare @olddescription nchar(50)
declare @oldstation nchar(20)
declare @oldparttype nchar(5)
declare @oldacseemode int
declare @olddisplayoption nchar(1)
declare @olddisplayorder int
declare @oldfilemap nchar(20)
--declare @oldqty int
declare @oldlvl int
set @delta_date =getdate()

select @max_delta_id = max(BOM_DIFF_Generation_ID) from FFC_BOMDeltas

set @max_delta_id = @max_Delta_id  + 1
if @max_delta_id is null
begin
  set @max_delta_id = 0
end

-- get materials added or subtracted from parts_level
-- BOM_DIFF_Type = 0  - no add or subtract
--                              = -1 not in newest BOM parts_level
--                               =1 not in old parts_level


-- BOM_DIFF_Type = -1, not in newest BOM (parts_level)



insert into FFC_SalesOrdersDeltas
(
SO_ID, SO_DIFF_Date, SO_OLD_SalesOrder, 
SO_OLD_SalesItem, SO_OLD_CustMatnr, SO_OLD_SerialProfile, 
SO_OLD_RequestDate, SO_OLD_ShipCond, SO_OLD_ShipCondType, 
SO_OLD_SoldTo, SO_OLD_INCOTERMS1, SO_OLD_INCOTERMS2, 
SO_OLD_SDPYMNTTERMS, SO_OLD_CUSTOMERPO, SO_OLD_FREIGHTTERMS, 
SO_OLD_FREIGHTTERMSTXT, SO_OLD_DELIVERYBLK, SO_OLD_DELIVERYBLKTXT, 
SO_OLD_SHIPTO, SO_OLD_CARRIER, SO_OLD_ADRNAME1, 
SO_OLD_ADRNAME2, SO_OLD_ADRSTREET, SO_OLD_ADRPOSTALCODE, 
SO_OLD_ADRCITY, SO_OLD_ADRSTATE, SO_OLD_ADRCOUNTRY, 
SO_OLD_ADRFAX, SO_OLD_ADRTEL, SO_OLD_ADRCOUNTRYDESC, 
SO_OLD_PURCHASEORDER, SO_OLD_PURCHASEITEM, SO_OLD_MATERIAL, 
SO_OLD_QTY, SO_OLD_UOM, SO_OLD_MATDESCRIPTION, 
SO_OLD_PRDHA, SO_OLD_PRICE, SO_OLD_TOTALPRICE, 
SO_OLD_REVISIONLVL, SO_OLD_WAERS, SO_OLD_POPYMNTTERMS, 
SO_OLD_POPYMNTTERMSTXT, SO_OLD_DELIVERYDATE
)
select
@max_delta_id, @delta_date,
FFC_SO_SalesOrder, FFC_SO_SalesItem, FFC_SO_CustMatnr, 
FFC_SO_SerialProfile, FFC_SO_RequestDate, FFC_SO_ShipCond, 
FFC_SO_ShipCondType, FFC_SO_SoldTo, FFC_SO_INCOTERMS1, 
FFC_SO_INCOTERMS2, FFC_SO_SDPYMNTTERMS, FFC_SO_CUSTOMERPO, 
FFC_SO_FREIGHTTERMS, FFC_SO_FREIGHTTERMSTXT, FFC_SO_DELIVERYBLK, 
FFC_SO_DELIVERYBLKTXT, FFC_SO_SHIPTO, FFC_SO_CARRIER, 
FFC_SO_ADRNAME1, FFC_SO_ADRNAME2, FFC_SO_ADRSTREET, 
FFC_SO_ADRPOSTALCODE, FFC_SO_ADRCITY, FFC_SO_ADRSTATE, 
FFC_SO_ADRCOUNTRY, FFC_SO_ADRFAX, FFC_SO_ADRTEL, 
FFC_SO_ADRCOUNTRYDESC, FFC_SO_PURCHASEORDER, FFC_SO_PURCHASEITEM, 
FFC_SO_MATERIAL, FFC_SO_QTY, FFC_SO_UOM, 
FFC_SO_MATDESCRIPTION, FFC_SO_PRDHA, FFC_SO_POPRICE, 
FFC_SO_TOTALPRICE, FFC_SO_REVISIONLVL, FFC_SO_WAERS, 
FFC_SO_POPYMNTTERMS, FFC_SO_POPYMNTTERMSTXT, FFC_SO_DELIVERYDATE
from SalesOrders where
FFC_SO_SalesOrder not in
(
select FFC_SO_SalesOrder from FFC_SalesOrders
)


-- BOM_DIFF_Type = 1, not in old BOM (parts_level)

insert into FFC_SalesOrdersDeltas
(
SO_ID, SO_DIFF_Date, 
SO_NEW_SalesOrder, SO_NEW_SalesItem, 
SO_NEW_CustMatnr, SO_NEW_SerialProfile, SO_NEW_RequestDate, 
SO_NEW_ShipCond, SO_NEW_ShipCondType, SO_NEW_SoldTo, 
SO_NEW_INCOTERMS1, SO_NEW_INCOTERMS2, SO_NEW_SDPYMNTTERMS, 
SO_NEW_CUSTOMERPO, SO_NEW_FREIGHTTERMS, SO_NEW_FREIGHTTERMSTXT, 
SO_NEW_DELIVERYBLK, SO_NEW_DELIVERYBLKTXT, 
SO_NEW_SHIPTO, SO_NEW_CARRIER, SO_NEW_ADRNAME1, 
SO_NEW_ADRNAME2, SO_NEW_ADRSTREET, SO_NEW_ADRPOSTALCODE, 
SO_NEW_ADRCITY, SO_NEW_ADRSTATE, SO_NEW_ADRCOUNTRY, 
SO_NEW_ADRFAX, SO_NEW_ADRTEL, SO_NEW_ADRCOUNTRYDESC, 
SO_NEW_PURCHASEORDER, SO_NEW_PURCHASEITEM, SO_NEW_MATERIAL, 
SO_NEW_QTY, SO_NEW_UOM, SO_NEW_MATDESCRIPTION, SO_NEW_PRDHA, 
SO_NEW_PRICE, SO_NEW_TOTALPRICE, SO_NEW_REVISIONLVL, 
SO_NEW_WAERS, SO_NEW_POPYMNTTERMS, SO_NEW_POPYMNTTERMSTXT, 
SO_NEW_DELIVERYDATE
)
select
@max_delta_id, @delta_date,
FFC_SO_SalesOrder, FFC_SO_SalesItem, 
FFC_SO_CustMatnr, FFC_SO_SerialProfile, FFC_SO_RequestDate, 
FFC_SO_ShipCond, FFC_SO_ShipCondType, FFC_SO_SoldTo, 
FFC_SO_INCOTERMS1, FFC_SO_INCOTERMS2, FFC_SO_SDPYMNTTERMS, 
FFC_SO_CUSTOMERPO, FFC_SO_FREIGHTTERMS, FFC_SO_FREIGHTTERMSTXT, 
FFC_SO_DELIVERYBLK, FFC_SO_DELIVERYBLKTXT, FFC_SO_SHIPTO, 
FFC_SO_CARRIER, FFC_SO_ADRNAME1, FFC_SO_ADRNAME2, 
FFC_SO_ADRSTREET, FFC_SO_ADRPOSTALCODE, FFC_SO_ADRCITY, 
FFC_SO_ADRSTATE, FFC_SO_ADRCOUNTRY, FFC_SO_ADRFAX, 
FFC_SO_ADRTEL, FFC_SO_ADRCOUNTRYDESC, FFC_SO_PURCHASEORDER, 
FFC_SO_PURCHASEITEM, FFC_SO_MATERIAL, FFC_SO_QTY, 
FFC_SO_UOM, FFC_SO_MATDESCRIPTION, FFC_SO_PRDHA, 
FFC_SO_POPRICE, FFC_SO_TOTALPRICE, FFC_SO_REVISIONLVL, 
FFC_SO_WAERS, FFC_SO_POPYMNTTERMS, FFC_SO_POPYMNTTERMSTXT, 
FFC_SO_DELIVERYDATE
 from FFC_SalesOrders where
FFC_SO_SalesOrder  not in
(
select FFC_SO_SalesOrder from SalesOrders
)



-- get differences in model numbers in both sets of parts_level
-- BOM_DIFF_Type = 0
-- BOM_ITEM_DIFF_Type = 0 - entry exists in both old and new but differs in a field
--                                         = -1  - entry does not exist in newest BOM parts_level
--                                         = 1 entry not in old parts_level

declare cur_FFCSalesOrders CURSOR for
select
FFC_SO_SalesOrder, 
FFC_SO_SalesItem, 
FFC_SO_CustMatnr, 
FFC_SO_SerialProfile, 
FFC_SO_RequestDate, 
FFC_SO_ShipCond, 
FFC_SO_ShipCondType, 
FFC_SO_SoldTo, 
FFC_SO_INCOTERMS1, 
FFC_SO_INCOTERMS2, 
FFC_SO_SDPYMNTTERMS, 
FFC_SO_CUSTOMERPO, 
FFC_SO_FREIGHTTERMS, 
FFC_SO_FREIGHTTERMSTXT, 
FFC_SO_DELIVERYBLK, 
FFC_SO_DELIVERYBLKTXT, 
FFC_SO_SHIPTO, 
FFC_SO_CARRIER, 
FFC_SO_ADRNAME1, 
FFC_SO_ADRNAME2, 
FFC_SO_ADRSTREET, 
FFC_SO_ADRPOSTALCODE, 
FFC_SO_ADRCITY, 
FFC_SO_ADRSTATE, 
FFC_SO_ADRCOUNTRY, 
FFC_SO_ADRFAX, 
FFC_SO_ADRTEL, 
FFC_SO_ADRCOUNTRYDESC, 
FFC_SO_PURCHASEORDER, 
FFC_SO_PURCHASEITEM, 
FFC_SO_MATERIAL, 
FFC_SO_QTY, 
FFC_SO_UOM, 
FFC_SO_MATDESCRIPTION, 
FFC_SO_PRDHA, 
FFC_SO_POPRICE, 
FFC_SO_TOTALPRICE, 
FFC_SO_REVISIONLVL, 
FFC_SO_WAERS, 
FFC_SO_POPYMNTTERMS, 
FFC_SO_POPYMNTTERMSTXT, 
FFC_SO_DELIVERYDATE from FFC_SalesOrders



declare cur_LocalFFCSalesOrders CURSOR for
select 
FFC_SO_SalesOrder, FFC_SO_SalesItem, 
FFC_SO_CustMatnr, FFC_SO_SerialProfile, FFC_SO_RequestDate, 
FFC_SO_ShipCond, FFC_SO_ShipCondType, FFC_SO_SoldTo, 
FFC_SO_INCOTERMS1, FFC_SO_INCOTERMS2, FFC_SO_SDPYMNTTERMS, 
FFC_SO_CUSTOMERPO, FFC_SO_FREIGHTTERMS, FFC_SO_FREIGHTTERMSTXT, 
FFC_SO_DELIVERYBLK, FFC_SO_DELIVERYBLKTXT, FFC_SO_SHIPTO, 
FFC_SO_CARRIER, FFC_SO_ADRNAME1, FFC_SO_ADRNAME2, 
FFC_SO_ADRSTREET, FFC_SO_ADRPOSTALCODE, FFC_SO_ADRCITY, 
FFC_SO_ADRSTATE, FFC_SO_ADRCOUNTRY, FFC_SO_ADRFAX, 
FFC_SO_ADRTEL, FFC_SO_ADRCOUNTRYDESC, FFC_SO_PURCHASEORDER, 
FFC_SO_PURCHASEITEM, FFC_SO_MATERIAL, FFC_SO_QTY, 
FFC_SO_UOM, FFC_SO_MATDESCRIPTION, FFC_SO_PRDHA, 
FFC_SO_POPRICE, FFC_SO_TOTALPRICE, FFC_SO_REVISIONLVL, 
FFC_SO_WAERS, FFC_SO_POPYMNTTERMS, FFC_SO_POPYMNTTERMSTXT, 
FFC_SO_DELIVERYDATE
from SalesOrders


open cur_FFCSalesOrders
FETCH NEXT  from  cur_FFCSalesOrders into
@newso,
@newsalesitem,
@newcustmatnr,
@newserialprofile,
@newrequestdate,
@newshipcond,
@newshipcondtype,
@newsoldto,
@newincoterms1,
@newincoterms2,
@newsdpymntterms,
@newcustomerpo,
@newfreightterms,
@newfreighttermstxt,
@newdeliveryblk,
@newdeliveryblktxt,
@newshipto,
@newcarrier,
@newadrname1,
@newadrname2,
@newadrstreet,
@newadrpostalcode,
@newadrcity,
@newadrstate,
@newadrcountry,
@newadrfax,
@newadrtel,
@newadrcountrydesc,
@newpurchaseorder,
@newpurchaseitem,
@newmaterial,
@newqty,
@newuom,
@newmatdescription,
@newprdha,
@newprice,
@newtotalprice,
@newrevisionlvl,
@newwaers,
@newpopymntterms,
@newpopymnttermstxt,
@newdeliverydate 


while @@Fetch_Status = 0
begin



if exists ( select FFC_SO_SalesOrder from SalesOrders where FFC_SO_SalesOrder = @newso)
begin
print 'found existing sales order'

select @oldso = FFC_SO_SalesOrder 
,
 @oldsalesitem = FFC_SO_SalesItem 
,
@oldcustmatnr =FFC_SO_CustMatnr
,
@oldserialprofile  = FFC_SO_SerialProfile
,
@oldrequestdate = FFC_SO_RequestDate
, 
@oldshipcond  = FFC_SO_ShipCond, 
@oldshipcondtype  =FFC_SO_ShipCondType, 
@oldsoldto  = FFC_SO_SoldTo, 
@oldincoterms1  = FFC_SO_INCOTERMS1, 
@oldincoterms2  =FFC_SO_INCOTERMS2,
/*
FFC_SO_SDPYMNTTERMS,  */
@oldcustomerpo  =FFC_SO_CUSTOMERPO,
@oldfreightterms  = FFC_SO_FREIGHTTERMS, 
 @oldfreighttermstxt  =FFC_SO_FREIGHTTERMSTXT, 
@olddeliveryblk  =FFC_SO_DELIVERYBLK
, 
@olddeliveryblktxt  =FFC_SO_DELIVERYBLKTXT, 
@oldshipto  = FFC_SO_SHIPTO, 
@oldcarrier  = FFC_SO_CARRIER, 
@oldadrname1  = FFC_SO_ADRNAME1, 
@oldadrname2  =FFC_SO_ADRNAME2, 
@oldadrstreet   = FFC_SO_ADRSTREET, 
 @oldadrpostalcode  = FFC_SO_ADRPOSTALCODE, 
@oldadrcity  =FFC_SO_ADRCITY, 
 @oldadrstate   =FFC_SO_ADRSTATE, 
@oldadrcountry   = FFC_SO_ADRCOUNTRY, 
@oldadrfax  = FFC_SO_ADRFAX, 
 @oldadrtel  = FFC_SO_ADRTEL, 
@oldadrcountrydesc  = FFC_SO_ADRCOUNTRYDESC, 
@oldpurchaseorder  = FFC_SO_PURCHASEORDER, 
@oldpurchaseitem  = FFC_SO_PURCHASEITEM,
@oldmaterial   = FFC_SO_MATERIAL, 
@oldqty =FFC_SO_QTY, 
 @olduom  = FFC_SO_UOM, 
@oldmatdescription  = FFC_SO_MATDESCRIPTION, 
@oldprdha   =FFC_SO_PRDHA, 
@oldprice   =FFC_SO_POPRICE, 
@oldtotalprice  =FFC_SO_TOTALPRICE, 
@oldrevisionlvl   = FFC_SO_REVISIONLVL, 
@oldwaers  = FFC_SO_WAERS, 
@oldpopymntterms  = FFC_SO_POPYMNTTERMS, 
@oldpopymnttermstxt  = FFC_SO_POPYMNTTERMSTXT, 
@olddeliverydate = FFC_SO_DELIVERYDATE

from SalesOrders 
where FFC_SO_SalesOrder = @newso 




if
   ( @newcustmatnr != @oldcustmatnr )
  OR ( @newserialprofile  != @oldserialprofile ) 
  OR ( @newrequestdate != @oldrequestdate )
  OR ( @newshipcond  !=  @oldshipcond  )
  OR ( @newshipcondtype  != @oldshipcondtype )  
  OR ( @newsoldto  != @oldsoldto  )
  OR ( @newincoterms1  != @oldincoterms1  )
  OR ( @newincoterms2  != @oldincoterms2  )
  OR ( @newcustomerpo  != @oldcustomerpo ) 
  OR ( @newfreightterms  != @oldfreightterms  )
  OR ( @newfreighttermstxt  != @oldfreighttermstxt )  
  OR ( @newdeliveryblk  != @olddeliveryblk   )
  OR ( @newdeliveryblktxt  != @olddeliveryblktxt  ) 
  OR ( @newshipto  != @oldshipto  )
  OR ( @newcarrier  != @oldcarrier  )
  OR ( @newadrname1  != @oldadrname1  ) 
  OR ( @newadrname2  != @oldadrname2  )
  OR ( @newadrstreet  != @oldadrstreet  )
  OR ( @newadrpostalcode  != @oldadrpostalcode )  
  OR ( @newadrcity  !=  @oldadrcity  )
  OR ( @newadrstate  != @oldadrstate  ) 
  OR ( @newadrcountry  != @oldadrcountry )  
  OR ( @newadrfax  != @oldadrfax  )
  OR ( @newadrtel  != @oldadrtel  )
  OR ( @newadrcountrydesc  != @oldadrcountrydesc )  
  OR ( @newpurchaseorder  !=  @oldpurchaseorder  )
  OR ( @newpurchaseitem != @oldpurchaseitem )
  OR ( @newmaterial  !=  @oldmaterial  )
  OR ( @newqty != @oldqty )
  OR ( @newuom  !=  @olduom  ) 
  OR ( @newmatdescription  != @oldmatdescription )  
  OR ( @newprdha  != @oldprdha  )
  OR ( @newprice  != @oldprice  )
  OR ( @newtotalprice != @oldtotalprice ) 
  OR ( @newrevisionlvl  != @oldrevisionlvl ) 
  OR ( @newwaers  !=   @oldwaers   )
  OR ( @newpopymntterms  != @oldpopymntterms ) 
  OR ( @newpopymnttermstxt  != @oldpopymnttermstxt )  
  OR ( @newdeliverydate !=   @olddeliverydate  )
begin
print 'hi'

insert into FFC_SalesOrdersDeltas
(
SO_OLD_SalesOrder, 
SO_OLD_SalesItem, 
SO_OLD_CustMatnr, 
SO_OLD_SerialProfile, 
SO_OLD_RequestDate, 
SO_OLD_ShipCond, 
SO_OLD_ShipCondType, 
SO_OLD_SoldTo, 
SO_OLD_INCOTERMS1, 
SO_OLD_INCOTERMS2, 

SO_OLD_CUSTOMERPO, 
SO_OLD_FREIGHTTERMS, 
SO_OLD_FREIGHTTERMSTXT, 
SO_OLD_DELIVERYBLK, 
SO_OLD_DELIVERYBLKTXT, 
SO_OLD_SHIPTO, 
SO_OLD_CARRIER, 
SO_OLD_ADRNAME1, 
SO_OLD_ADRNAME2, 
SO_OLD_ADRSTREET, 
SO_OLD_ADRPOSTALCODE, 
SO_OLD_ADRCITY,
 SO_OLD_ADRSTATE, 
SO_OLD_ADRCOUNTRY, 
SO_OLD_ADRFAX, 
SO_OLD_ADRTEL,
 SO_OLD_ADRCOUNTRYDESC, 
SO_OLD_PURCHASEORDER, 
SO_OLD_PURCHASEITEM,
 SO_OLD_MATERIAL, 
SO_OLD_QTY, 
SO_OLD_UOM, 
SO_OLD_MATDESCRIPTION, 
SO_OLD_PRDHA, 
SO_OLD_PRICE, 
SO_OLD_TOTALPRICE,
 SO_OLD_REVISIONLVL, 
SO_OLD_WAERS, 
SO_OLD_POPYMNTTERMS, 
SO_OLD_POPYMNTTERMSTXT, 
SO_OLD_DELIVERYDATE,
 SO_NEW_SalesOrder, 
SO_NEW_SalesItem, 
SO_NEW_CustMatnr, 
SO_NEW_SerialProfile, 
SO_NEW_RequestDate, 
SO_NEW_ShipCond, 
SO_NEW_ShipCondType,
 SO_NEW_SoldTo, 
SO_NEW_INCOTERMS1, 
SO_NEW_INCOTERMS2, 

SO_NEW_CUSTOMERPO, 
SO_NEW_FREIGHTTERMS,
 SO_NEW_FREIGHTTERMSTXT, 
SO_NEW_DELIVERYBLK, 
SO_NEW_DELIVERYBLKTXT, 
SO_NEW_SHIPTO,
 SO_NEW_CARRIER,
 SO_NEW_ADRNAME1, 
SO_NEW_ADRNAME2, 
SO_NEW_ADRSTREET, 
SO_NEW_ADRPOSTALCODE, 
SO_NEW_ADRCITY,
 SO_NEW_ADRSTATE, 
SO_NEW_ADRCOUNTRY, 
SO_NEW_ADRFAX, 
SO_NEW_ADRTEL, 
SO_NEW_ADRCOUNTRYDESC, 
SO_NEW_PURCHASEORDER,
 SO_NEW_PURCHASEITEM, 
SO_NEW_MATERIAL, 
SO_NEW_QTY, 
SO_NEW_UOM,
 SO_NEW_MATDESCRIPTION,
 SO_NEW_PRDHA, 
SO_NEW_PRICE, 
SO_NEW_TOTALPRICE,
 SO_NEW_REVISIONLVL, 
SO_NEW_WAERS, 
SO_NEW_POPYMNTTERMS,
 SO_NEW_POPYMNTTERMSTXT, 
SO_NEW_DELIVERYDATE
)
values
(
@oldso,
@oldsalesitem,
@oldcustmatnr,
@oldserialprofile,
@oldrequestdate,
@oldshipcond,
@oldshipcondtype,
@oldsoldto,
@oldincoterms1,
@oldincoterms2,
@oldcustomerpo,
@oldfreightterms,
@oldfreighttermstxt,
@olddeliveryblk,
@olddeliveryblktxt,
@oldshipto,
@oldcarrier,
@oldadrname1,
@oldadrname2,
@oldadrstreet,
@oldadrpostalcode,
@oldadrcity,
@oldadrstate,
@oldadrcountry,
@oldadrfax,
@oldadrtel,
@oldadrcountrydesc,
@oldpurchaseorder,
@oldpurchaseitem,
@oldmaterial,
@oldqty,
@olduom,
@oldmatdescription,
@oldprdha,
@oldprice,
@oldtotalprice,
@oldrevisionlvl,
@oldwaers,
@oldpopymntterms,
@oldpopymnttermstxt,
@olddeliverydate ,

@newso,
@newsalesitem,
@newcustmatnr,
@newserialprofile,
@newrequestdate,
@newshipcond,
@newshipcondtype,
@newsoldto,
@newincoterms1,
@newincoterms2,
@newcustomerpo,
@newfreightterms,
@newfreighttermstxt,
@newdeliveryblk,
@newdeliveryblktxt,
@newshipto,
@newcarrier,
@newadrname1,
@newadrname2,
@newadrstreet,
@newadrpostalcode,
@newadrcity,
@newadrstate,
@newadrcountry,
@newadrfax,
@newadrtel,
@newadrcountrydesc,
@newpurchaseorder,
@newpurchaseitem,
@newmaterial,
@newqty,
@newuom,
@newmatdescription,
@newprdha,
@newprice,
@newtotalprice,
@newrevisionlvl,
@newwaers,
@newpopymntterms,
@newpopymnttermstxt,
@newdeliverydate 
)

end





























end

print 'fetching next'
FETCH NEXT  from  cur_FFCSalesOrders into
@newso,
@newsalesitem,
@newcustmatnr,
@newserialprofile,
@newrequestdate,
@newshipcond,
@newshipcondtype,
@newsoldto,
@newincoterms1,
@newincoterms2,
@newsdpymntterms,
@newcustomerpo,
@newfreightterms,
@newfreighttermstxt,
@newdeliveryblk,
@newdeliveryblktxt,
@newshipto,
@newcarrier,
@newadrname1,
@newadrname2,
@newadrstreet,
@newadrpostalcode,
@newadrcity,
@newadrstate,
@newadrcountry,
@newadrfax,
@newadrtel,
@newadrcountrydesc,
@newpurchaseorder,
@newpurchaseitem,
@newmaterial,
@newqty,
@newuom,
@newmatdescription,
@newprdha,
@newprice,
@newtotalprice,
@newrevisionlvl,
@newwaers,
@newpopymntterms,
@newpopymnttermstxt,
@newdeliverydate 






end







close cur_FFCSalesOrders
deallocate cur_FFCSalesOrders



/*
declare cur_FFCPartsLevel CURSOR for
select SAP_Model, 
Part_Number, Rev, Description, 
BOM_Date_Time, Station, Part_Type,
 ACSEEMode, Display_Option, Display_Order, 
FileMap, Qty, Lvl
 from FFC_Parts_Level order by SAP_Model, Part_Number


declare cur_LocalPartsLevel CURSOR for
select SAP_Model, 
Part_Number, Rev, Description, 
BOM_Date_Time, Station, Part_Type,
 ACSEEMode, Display_Option, Display_Order, 
FileMap, Qty, Lvl
 from Parts_Level  where not exists
(
select * from FFC_Parts_Level where FFC_Parts_Level.SAP_Model = SAP_Model and FFC_Parts_Level.Part_Number = Part_Number
)
order by SAP_Model, Part_Number



open cur_FFCPartsLevel

Fetch Next from cur_FFCPartsLevel into 
@newso,
@newpartnumber,
@newrev,
@newdescription ,
@newstation ,
@newparttype ,
@newacseemode ,
@newdisplayoption,
@newdisplayorder,
@newfilemap,
@newqty,
@newlvl 

while @@Fetch_Status = 0
begin


if exists( select SAP_Model from Parts_Level where SAP_Model = @newso and part_number = @newpartnumber )
begin
select @oldso = SAP_Model, @oldpartnumber = part_number,@oldrev = rev,
@olddescription = description, @oldstation = station, @oldparttype = part_type,
@oldacseemode = acseemode, @olddisplayoption = display_option, @olddisplayorder = display_order,
@oldfilemap = filemap, @oldqty = qty, @oldlvl = lvl
from Parts_Level where SAP_Model = @newso and part_number = @newpartnumber

if ( @newrev != @oldrev ) or ( @newdescription != @olddescription )
begin
insert into FFC_BOMDeltas
(
BOM_DIFF_Generation_ID, BOMDIFF_Date, 
 BOM_DIFF_Type, BOM_ITEM_DIFF_Type, 
OLD_SAP_Model, OLD_Part_Number, OLD_Rev, 
OLD_Description,  OLD_Station, 
OLD_Part_Type, OLD_ACSEEMode, OLD_Display_Option, 
OLD_Display_Order, OLD_FileMap, OLD_Qty, 
OLD_Lvl, NEW_SAP_Model, NEW_Part_Number, 
NEW_Rev, NEW_Description,  
NEW_Station, NEW_Part_Type, NEW_ACSEEMode, 
NEW_Display_Option, NEW_Display_Order, 
NEW_FileMap, NEW_Qty, NEW_Lvl
)
values
(
@max_delta_id, @delta_date,
0,0,
@oldso, @oldpartnumber,@oldrev,
@olddescription, @oldstation , 
@oldparttype,@oldacseemode , @olddisplayoption ,
 @olddisplayorder ,@oldfilemap , @oldqty , @oldlvl ,

@newso, @newpartnumber,@newrev,
@newdescription, @newstation , 
@newparttype,@newacseemode , @newdisplayoption ,
 @newdisplayorder ,@newfilemap , @newqty , @newlvl 
)
end

end
else
begin
insert into FFC_BOMDeltas
(
BOM_DIFF_Generation_ID, BOMDIFF_Date, 
--BOMDIFF_SO, BOMDIFF_PO, 
--BIMDIFF_PackageID, 
BOM_DIFF_Type, BOM_ITEM_DIFF_Type, 
NEW_SAP_Model, NEW_Part_Number, NEW_Rev, 
NEW_Description,  NEW_Station, 
NEW_Part_Type, NEW_ACSEEMode, NEW_Display_Option, 
NEW_Display_Order, NEW_FileMap, NEW_Qty, 
NEW_Lvl
)
values
(
@max_delta_id, @delta_date,
0,1,
@newso, @newpartnumber,@newrev,
@newdescription, @newstation , 
@newparttype,@newacseemode , @newdisplayoption ,
 @newdisplayorder ,@newfilemap , @newqty , @newlvl
)
end


   Fetch Next from cur_FFC_PartsLevel into
@newso,
@newpartnumber,
@newrev,
@newdescription ,
@newstation ,
@newparttype ,
@newacseemode ,
@newdisplayoption,
@newdisplayorder,
@newfilemap,
@newqty,
@newlvl 
end

close cur_FFCPartsLevel
Deallocate cur_FFCPartsLevel




insert into FFC_BomDeltas
(
BOM_DIFF_Generation_ID, BOMDIFF_Date, 
--BOMDIFF_SO, BOMDIFF_PO, 
--BIMDIFF_PackageID, 
BOM_DIFF_Type, BOM_ITEM_DIFF_Type, 
OLD_SAP_Model, OLD_Part_Number, OLD_Rev, 
OLD_Description, OLD_BOM_Date_Time, OLD_Station, 
OLD_Part_Type, OLD_ACSEEMode, OLD_Display_Option, 
OLD_Display_Order, OLD_FileMap, OLD_Qty, 
OLD_Lvl
)
select
@max_delta_id, @delta_date,
0,-1,
 SAP_Model, 
Part_Number, Rev, Description, 
BOM_Date_Time, Station, Part_Type,
 ACSEEMode, Display_Option, Display_Order, 
FileMap, Qty, Lvl
 from Parts_Level  where not exists
(
select * from FFC_Parts_Level where FFC_Parts_Level.SAP_Model = SAP_Model and FFC_Parts_Level.Part_Number = Part_Number
)


*/


--close cur_LocalFFCSalesOrders
deallocate cur_LocalFFCSalesOrders
GO