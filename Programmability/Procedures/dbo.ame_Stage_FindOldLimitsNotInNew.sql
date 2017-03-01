SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_FindOldLimitsNotInNew]
-- Define input parameters
	@Station_Name 	char(20) = NULL,
	@SAP_Model_Name char(20)=NULL,
             @ACSEEMode int,
            @srcStation_Name char(20),
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



declare cur_OldNotInNew cursor for select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, OpportunitiesforFail from subtestlimits 
where station_name = @Station_Name and SAP_Model_Name = @SAP_Model_Name and ACSEEMode = @ACSEEMode and not exists (
select   SubTest_Name from Stage_Subtestlimits where (Station_Name=@Station_Name or station_name = @srcStation_Name ) and
 SAP_Model_Name = @SAP_Model_Name and  ACSEEMode = @ACSEEMode and TableUser = @username and subtest_name = subtestlimits.subtest_name
and Staging_Type='NEW'
)  



open cur_OldNotInNew


FETCH NEXT from  cur_OldNotInNew into
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
   @exist_oppsforfail

WHILE @@FETCH_STATUS = 0 
begin


insert into Stage_Subtestlimits
(
 Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, 
Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, OpportunitiesforFail, Staging_Type,TableUser
)
values
(
@Station_Name ,
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
   ' 1/1/1970', 
   0 ,
1,
0,
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





FETCH NEXT from  cur_OldNotInNew into
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
   @exist_oppsforfail
end

close cur_OldNotInNew
deallocate cur_OldNotInNew
GO