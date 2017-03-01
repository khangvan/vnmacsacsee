SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_DOSFALCONFINAL] AS
declare @sapmodel char(20)

declare cur_Models CURSOR FOR
SELECT DIgits from [ACSEEState].[dbo].Option_7 where Digits like '7%'

open cur_Models

FETCH NEXT from cur_Models into @sapmodel

while @@FETCH_STATUS = 0
BEGIN
print @sapmodel




insert into subtestlimits
(
Station_Name,
Subtest_Name,
SAP_Model_Name,
Limit_TYpe,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
Author,
ACSEEMode,
SPCParm,
HARD_UL,
Hard_LL,
Limit_Date,
ProductGroup_Mask
)
values
(
'FALCONDOSFINAL',
'DOSFINALTEST',
@sapmodel,
'S',
100,0,
'passfail',
'',
'',
'Pass or Fail',
'wdkurth',
0,
'Y',
100,0,
getdate(),
0
)


FETCH NEXT from cur_Models into @sapmodel


END

close cur_Models
deallocate cur_Models
GO