SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetBOMDeltas]
 AS
declare @max_delta_id int
declare @delta_date datetime

declare @newsapmodel nchar(20)
declare @newpartnumber nchar(20)
declare @newrev nchar(3)
declare @newdescription nchar(50)
declare @newstation nchar(20)
declare @newparttype nchar(5)
declare @newacseemode int
declare @newdisplayoption nchar(1)
declare @newdisplayorder int
declare @newfilemap nchar(20)
declare @newqty int
declare @newlvl int

declare @oldsapmodel nchar(20)
declare @oldpartnumber nchar(20)
declare @oldrev nchar(3)
declare @olddescription nchar(50)
declare @oldstation nchar(20)
declare @oldparttype nchar(5)
declare @oldacseemode int
declare @olddisplayoption nchar(1)
declare @olddisplayorder int
declare @oldfilemap nchar(20)
declare @oldqty int
declare @oldlvl int
set @delta_date =getdate()

select @max_delta_id = max(BOM_DIFF_Generation_ID) from FFC_BOMDeltas

set @max_delta_id = @max_Delta_id  + 1

-- get materials added or subtracted from parts_level
-- BOM_DIFF_Type = 0  - no add or subtract
--                              = -1 not in newest BOM parts_level
--                               =1 not in old parts_level


-- BOM_DIFF_Type = -1, not in newest BOM (parts_level)



insert into FFC_BOMDeltas
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
-1,0,
SAP_Model, Part_Number, Rev,
Description, BOM_Date_Time, Station, 
Part_Type, ACSEEMode, Display_Option,
Display_Order, FileMap, Qty,
Lvl
from parts_level where
SAP_Model not in
(
select SAP_Model from FFC_Parts_Level
)


-- BOM_DIFF_Type = 1, not in old BOM (parts_level)

insert into FFC_BOMDeltas
(
BOM_DIFF_Generation_ID, BOMDIFF_Date, 
--BOMDIFF_SO, BOMDIFF_PO, 
--BIMDIFF_PackageID, 
BOM_DIFF_Type, BOM_ITEM_DIFF_Type, 
NEW_SAP_Model, NEW_Part_Number, NEW_Rev, 
NEW_Description, NEW_BOM_Date_Time, NEW_Station, 
NEW_Part_Type, NEW_ACSEEMode, NEW_Display_Option, 
NEW_Display_Order, NEW_FileMap, NEW_Qty, 
NEW_Lvl
)
select
@max_delta_id, @delta_date,
1,0,
SAP_Model, Part_Number, Rev,
Description, BOM_Date_Time, Station, 
Part_Type, ACSEEMode, Display_Option,
Display_Order, FileMap, Qty,
Lvl
from FFC_parts_level where
SAP_Model not in
(
select SAP_Model from Parts_Level
)



-- get differences in model numbers in both sets of parts_level
-- BOM_DIFF_Type = 0
-- BOM_ITEM_DIFF_Type = 0 - entry exists in both old and new but differs in a field
--                                         = -1  - entry does not exist in newest BOM parts_level
--                                         = 1 entry not in old parts_level

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
@newsapmodel,
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


if exists( select SAP_Model from Parts_Level where SAP_Model = @newsapmodel and part_number = @newpartnumber )
begin
select @oldsapmodel = SAP_Model, @oldpartnumber = part_number,@oldrev = rev,
@olddescription = description, @oldstation = station, @oldparttype = part_type,
@oldacseemode = acseemode, @olddisplayoption = display_option, @olddisplayorder = display_order,
@oldfilemap = filemap, @oldqty = qty, @oldlvl = lvl
from Parts_Level where SAP_Model = @newsapmodel and part_number = @newpartnumber

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
@oldsapmodel, @oldpartnumber,@oldrev,
@olddescription, @oldstation , 
@oldparttype,@oldacseemode , @olddisplayoption ,
 @olddisplayorder ,@oldfilemap , @oldqty , @oldlvl ,

@newsapmodel, @newpartnumber,@newrev,
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
@newsapmodel, @newpartnumber,@newrev,
@newdescription, @newstation , 
@newparttype,@newacseemode , @newdisplayoption ,
 @newdisplayorder ,@newfilemap , @newqty , @newlvl
)
end


   Fetch Next from cur_FFC_PartsLevel into
@newsapmodel,
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
GO