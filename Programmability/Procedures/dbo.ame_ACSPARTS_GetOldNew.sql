SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ACSPARTS_GetOldNew]
 AS


declare @local_parttypes table (
           [Result_Digits] [char] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Description_Parse_Value] [char] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Check_Order] [int] NOT NULL 
)




insert into @local_parttypes
(
Result_Digits,
Description_Parse_Value,
CHeck_Order
)
SELECT Result_Digits, Description_Parse_Value, Check_Order FROM PARTTYPE ORDER BY CHECK_ORDER




declare cur_parttype CURSOR for
SELECT Result_Digits, Description_Parse_Value, Check_Order FROM @local_parttypes ORDER BY CHECK_ORDER

declare cur_parts CURSOR for
Select ALLACSPARTS_ID , ALLACSPARTS_part_number  , ALLACSPARTS_Description from ALLACSPARTS



declare @temppartype char(3)
declare @resultdigits char(3)
declare @descriptionparsevalue char (20)
declare @partid int
declare @partnumber char(20)
declare @partdescription char(50)


open cur_parts
Fetch next from cur_parts into @partid, @partnumber, @partdescription
while @@FETCH_STATUS = 0 
begin
--    if ((( substring(@partnumber,1,1) > '9' ) or (substring(@partnumber,1,2) = '62' )) and ( substring(@partnumber,1,1) != 'F' ) and substring(@partnumber,1,1) !='P' ) 
--    begin
--       exec ame_ACSPARTS_CalculateOldType @partid, @partnumber, @partdescription
--       exec ame_ACSPARTS_CalculateNewType @partid, @partnumber, @partdescription
--       exec ame_ACSPARTS_CalculateNewNewType @partid, @partnumber, @partdescription
       exec  ame_ACSPARTS_CalculateAllType @partid, @partnumber, @partdescription
--   end
Fetch next from cur_parts into @partid, @partnumber, @partdescription
end

close cur_parts
deallocate cur_parts
GO