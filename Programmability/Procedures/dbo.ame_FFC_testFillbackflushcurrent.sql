SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_testFillbackflushcurrent]
@count int,
@PO nchar(50),
@material nchar(50),
@basesn nchar(20)
 AS
set nocount on

declare @icount int
declare @nextsn nchar(20)




set @icount = 0 

while @icount < @count
begin

DECLARE @charNewValue char(20)
--SET @charNewValue = LEFT(@basesn, 6) +        RIGHT ('000'+ CAST(@icount AS varchar(3)), 3 )
--set @nextsn= @basesn  +  cast(@icount as varchar)
--print @charNewValue
SET @nextsn = LEFT(@basesn, 6) +        RIGHT ('000'+ CAST(@icount AS varchar(3)), 3 )
print @nextsn

insert into FFC_BackFlush_Current
(
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo, 
FFC_BackFlush_Date, 
FFC_BackFlush_Locked, 
FFC_BackFlush_CountQty
)
values
(
@PO,
2,
@material,
1,
@nextsn,
getdate(),
0,
@count
)


set @icount = @icount + 1
end
GO