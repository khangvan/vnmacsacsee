SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ACSPARTS_CalculateAllType] 
@partid int, 
@partnumber nchar(4), 
@partdescription nchar(50)
 AS

set nocount on








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
SELECT Result_Digits, Description_Parse_Value, Check_Order FROM PARTTYPEProposed ORDER BY CHECK_ORDER




declare cur_parttype CURSOR for
SELECT Result_Digits, Description_Parse_Value FROM @local_parttypes ORDER BY CHECK_ORDER


declare @temppartype char(3)
declare @temppartparsevalue char(20)
declare @resultdigits char(3)
declare @descriptionparsevalue char (20)
declare @foundpos int

open cur_parttype

set @temppartype = 'X'
set @temppartparsevalue=' '

FETCH Next FROM cur_parttype into @resultdigits, @descriptionparsevalue

WHILE @@FETCH_STATUS = 0
begin


set @foundpos = 0
 exec ame_ACSPARTS_FINDSTR @descriptionparsevalue,@partdescription, @foundpos OUTPUT

if @foundpos > 0  
begin
print 'MATCH*****************************************'
print @foundpos
    set @temppartype = @resultdigits
    set @temppartparsevalue = @descriptionparsevalue
end



FETCH Next FROM cur_parttype into @resultdigits, @descriptionparsevalue

end


print '---------FOUND-----'
print @temppartype

print @temppartparsevalue
print @partdescription

update ALLACSPARTS set  ALLACSPARTS_AllCalcType=@temppartype where  ALLACSPARTS_ID = @partid

close cur_parttype
deallocate cur_parttype
GO