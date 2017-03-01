SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE proc [dbo].[ameNET_GetSpecific_subtestlimits]
-- Define input parameters
	@astation	char(20) = NULL,
              @model    char(20) = null -- ACS_Serial
-- Define code
AS
set nocount on

declare @testname char(20)

select @testname = TestName from stations where station_name=@astation


if @testname = 'BSCAN'
begin
if isnumeric(substring(@astation,len(@astation) -1,1)) =1
begin

		select  substring(@astation,1,len(@astation)-1), SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, isnull(OpportunitiesforFail,0) as OpportunitiesforFail   from SubTestLimits 
			where Station_Name=@TESTNAME and sap_model_name = @model

		return
end
end


	--Verify that non-NULLable parameter(s) have values
	if @astation is NULL
	   begin
		raiserror ('E504.1 Illegal Parameter Value. You must specify an Station Name.',
			16,1) with nowait
		return
	   end
		-- Create output cursor

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=@astation)
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, isnull(OpportunitiesforFail,0)  as OpportunitiesforFail    from SubTestLimits 
			where Station_Name=@astation and sap_model_name = @model
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=@astation+'1')
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, isnull(OpportunitiesforFail,0)   as OpportunitiesforFail  from SubTestLimits 
			where Station_Name=@astation+'1' and sap_model_name = @model
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1) )
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, isnull(OpportunitiesforFail,0)  as OpportunitiesforFail   from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1) and sap_model_name = @model
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1)+'1' )
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, isnull(OpportunitiesforFail,0)  as OpportunitiesforFail  from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1)+'1' and sap_model_name = @model
		return
	   end



-- Create the Stored Procedure
GO