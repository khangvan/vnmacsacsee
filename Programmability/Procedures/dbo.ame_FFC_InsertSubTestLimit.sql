SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_FFC_InsertSubTestLimit]
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
             @ProductGroup_mask int

AS
set nocount on


insert into subtestlimits
(
Station_Name,
SubTest_Name,
SAP_Model_Name,
Limit_Type,
UL,
LL,
strLimit,
flgLimit,
Units,
Description,
Author,
ACSEEMode,
SPCParm,
Hard_UL,
Hard_LL,
Limit_Date,
ProductGroup_Mask
)
values
(
	@Station_Name,
	@subtest_name,
	@SAP_Model_Name,
             @Limit_Type,
             @UL,
             @LL,
             @strLimit,
             @flgLimit,
             @Units,
             @Description,
             @Author,
             @ACSEEMode,
             @SPCParm,
             @Hard_UL,
             @Hard_LL,
             @Limit_Date,
             @ProductGroup_mask
)





select 'OK'
GO