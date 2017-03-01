SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_QuickLimitLookup] 
@acsserial char(20),
@model char(20),
@station char(20),
@mode int
 AS

set nocount on

if @mode = 1 
begin


if ( len(rtrim(@station)) = 0 )
begin
select 
Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail
 from subtestlimits WITH (NOLOCK)  where sap_model_name in ( select distinct sap_model from testlog  WITH (NOLOCK) where acs_serial = @acsserial )
end
else
begin
select 
Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail
 from subtestlimits  WITH (NOLOCK)  where sap_model_name in ( select distinct sap_model from testlog  WITH (NOLOCK) where acs_serial = @acsserial ) and station_name = @station
end

end

else
begin

if ( len(rtrim(@station)) = 0 )
begin
select 
Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail
 from subtestlimits  WITH (NOLOCK)  where sap_model_name = @model
end
else
begin
select 
Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail
 from subtestlimits  WITH (NOLOCK)  where sap_model_name = @model and station_name = @station
end


end
GO