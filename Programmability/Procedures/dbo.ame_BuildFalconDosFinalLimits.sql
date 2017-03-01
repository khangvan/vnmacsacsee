SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_BuildFalconDosFinalLimits]
 AS

declare @sapmodel char(20)

declare cur_Models CURSOR FOR
select Digits from [ACSEEState].[dbo].Option_7


open cur_Models
FETCH NEXT FROM cur_Models into @sapmodel
WHILE @@FETCH_Status = 0
begin
print @sapmodel

FETCH NEXT FROM cur_Models into @sapmodel
end


close cur_Models
deallocate cur_Models
/*
Select Station_Name, 'DOSFINALTEST', @sapmodel, Limit_Type, UL, LL, strLimit, flgLimit,Units,Description, AUthor, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask
from Subtestlimits
where Station_Name='FalconDosFInal' and Subtest_Name='DOSFINALTest' and SAP_Model_Name='3-WDK'
*/
GO