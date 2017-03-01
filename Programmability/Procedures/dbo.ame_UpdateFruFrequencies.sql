SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_UpdateFruFrequencies]
AS

declare @testname char(30)

declare cur_Tests CURSOR FOR
 Select distinct TST_TestName from tests where tst_fPerformTest = 1

delete from fru_Frequency
insert into fru_frequency
(
Fru_Fru_ID,
Fru_Category,
Fru_Type,
Fru_Frequency
)
select  RFU_Fru_ID,TST_TestName, RFU_Type, count(*) as num
from SAP_NewRepairFrus inner join RawFruFailureLog on RFU_Fru_ID = FLG_Fru_ID
inner join Tests on substring(FLG_Station,1,len(FLG_Station) -1 ) = Tests.TST_TestName
group by RFU_Fru_ID, TST_TestName, RFU_Type
order by num desc


delete from Fru_AllFreqTest


open cur_Tests


FETCH NEXT FROM cur_Tests into @testname
WHILE @@FETCH_STATUS = 0
BEGIN


insert into Fru_AllFreqTest
(
FALT_fruCode,
FALT_cFruCode,
FALT_Fru_ID,
FALT_Description,
FALT_Testname,
FALT_Type,
FALT_Frequency
)
select RFU_FruCode, RFU_cFruCode, RFU_Fru_ID, RFU_FruDescription,isnull(Fru_Category, @testname), RFU_Type,isnull(Fru_Frequency,0)
from SAP_NewRepairFrus
left outer join
(
select Fru_Fru_ID, Fru_Category, Fru_Frequency 
from Fru_Frequency
where Fru_Category = @testname
) v 
on v.Fru_Fru_ID = RFU_Fru_ID





FETCH NEXT FROM cur_Tests into @testname
END


close cur_Tests

Deallocate cur_Tests






insert into Fru_AllFreqTest
(
FALT_fruCode,
FALT_cFruCode,
FALT_Fru_ID,
FALT_Description,
FALT_Testname,
FALT_Type,
FALT_Frequency
)
select 
FALT_fruCode,
FALT_cFruCode,
FALT_Fru_ID,
FALT_Description,
'BSCAN1',
FALT_Type,
FALT_Frequency
from Fru_AllFreqTest
where FALT_Testname='BSCAN'
GO