SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[me_ACSPARTS_CalculateOldType] 
@partid int, 
@partnumber char(4), 
@partdescription  char(50)
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
SELECT Result_Digits, Description_Parse_Value, Check_Order FROM PARTTYPE ORDER BY CHECK_ORDER




declare cur_parttype CURSOR for
SELECT Result_Digits, Description_Parse_Value FROM @local_parttypes ORDER BY CHECK_ORDER



declare @temppartype char(3)
declare @resultdigits char(3)
declare @descriptionparsevalue char (20)



open cur_parttype

FETCH NEXT FROM cur_parttype into @resultdigits, @descriptionparsevalue

while @@FETCH_STATUS = 0
begin
FETCH NEXT FROM cur_parttype into @resultdigits, @descriptionparsevalue
end


close cur_parttype
deallocate cur_parttype
GO