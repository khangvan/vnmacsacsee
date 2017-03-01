SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_RecordLimit]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@Subtest_Name char(20)=NULL,
	@SAP_Model_Name char(20)=NULL,
             @Limit_Type char(1),
             @UL real,
             @LL real,
             @strLimit char(40),
             @flgLimit char(1),
             @Units char(10),
             @Description char(50),
             @Author char(25),
             @ACSEEMode int,
             @SPCParm char(1),
             @Hard_UL real,
             @Hard_LL real,
             @Limit_Date datetime,
             @ProductGroup_mask int,
             @note char(2000),
             @oppsforfail int,
             @destStation_Name   char(20) = NULL,
              @username char(50),
             @retcode int OUTPUT

AS
set nocount on


declare @exist_Station_Name char(20) 
declare @exist_Subtest_Name char(20)
declare @exist_SAP_Model_Name char(20)
declare @exist_Limit_Type char(1)
declare @exist_UL real
declare @exist_LL real
declare @exist_strLimit char(40)
declare @exist_flgLimit char(1)
declare @exist_Units char(10)
declare @exist_Description char(50)
declare @exist_Author char(25)
declare @exist_ACSEEMode int
declare @exist_SPCParm char(1)
declare @exist_Hard_UL real
declare @exist_Hard_LL real
declare @exist_Limit_Date datetime
declare @exist_ProductGroup_mask int
declare @exist_note char(2000)
declare @exist_noteid int
declare @exist_oppsforfail int





declare @existcount int

set @retcode = 0

select @existcount = count(*) from subtestlimits where 
station_Name = @destStation_name and
Subtest_Name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name
and ACSEEMode = @ACSEEMode

select @existcount

print @existcount
if @@ERROR <>0
begin
  set @retcode = 1
end

if @existcount > 0

begin
select 'update'



select
 @exist_Station_Name  =Station_Name,
 @exist_Subtest_Name  = Subtest_Name,
 @exist_SAP_Model_Name = SAP_Model_Name,
 @exist_Limit_Type = Limit_TYpe,
 @exist_UL = UL,
 @exist_LL  = LL,
 @exist_strLimit = strLimit,
 @exist_flgLimit = flgLimit,
 @exist_Units = Units,
 @exist_Description = Description,
 @exist_Author = Author,
 @exist_ACSEEMode = ACSEEMode,
 @exist_SPCParm = SPCParm,
 @exist_Hard_UL =Hard_UL,
 @exist_Hard_LL  = Hard_LL,
 @exist_Limit_Date = Limit_Date,
 @exist_ProductGroup_mask = ProductGroup_mask,
@exist_noteid = note_id,
@exist_oppsforfail = opportunitiesforfail
from subtestlimits where 
station_Name = @destStation_Name and
Subtest_Name = @Subtest_Name and
SAP_Model_Name = @SAP_Model_Name
and ACSEEMode = @ACSEEMode


insert into Stage_Subtestlimits
(
 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, OpportunitiesforFail, Staging_Type, TableUser
)
values
(
@Station_Name ,
  @Subtest_Name ,
  @SAP_Model_Name, 
  @Limit_Type ,
  @UL ,
  @LL ,
  @strLimit ,
  @flgLimit ,
  @Units ,
  @Description ,
  @Author ,
  @ACSEEMode ,
  @SPCParm ,
  @Hard_UL ,
  @Hard_LL ,
  @Limit_Date ,
  @ProductGroup_mask ,
1,
@oppsforfail,
'NEW',
@username
)





insert into Stage_Subtestlimits
(
 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, OpportunitiesforFail, Staging_Type, TableUser
)
values
(
  @exist_Station_Name ,
   @exist_Subtest_Name, 
   @exist_SAP_Model_Name ,
   @exist_Limit_Type ,
   @exist_UL ,
   @exist_LL ,
   @exist_strLimit ,
   @exist_flgLimit ,
   @exist_Units ,
   @exist_Description ,
   @exist_Author ,
   @exist_ACSEEMode ,
   @exist_SPCParm ,
   @exist_Hard_UL ,
   @exist_Hard_LL ,
   @exist_Limit_Date, 
   @exist_ProductGroup_mask ,
2,
@exist_oppsforfail,
'OLD',
@username
)




end
else
begin
select 'new limit'



insert into Stage_Subtestlimits
(
 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, OpportunitiesforFail, Staging_Type,TableUser
)
values
(
@Station_Name ,
  @Subtest_Name ,
  @SAP_Model_Name, 
  @Limit_Type ,
  @UL ,
  @LL ,
  @strLimit ,
  @flgLimit ,
  @Units ,
  @Description ,
  @Author ,
  @ACSEEMode ,
  @SPCParm ,
  @Hard_UL ,
  @Hard_LL ,
  @Limit_Date ,
  @ProductGroup_mask ,
1,
@oppsforfail,
'NEW',
@username
)



insert into Stage_Subtestlimits
(
 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, OpportunitiesforFail, Staging_Type,TableUser
)
values
(
@destStation_Name ,
    ' ', 
   ' ' ,
   ' ' ,
   0 ,
   0 ,
   ' ' ,
   ' ' ,
   ' ' ,
   ' ' ,
   ' ' ,
   0 ,
   ' ' ,
   0 ,
   0 ,
   ' 1/1/1960', 
   0 ,
2,
0,
'OLD',
@username
)


end
select 'OK'
GO