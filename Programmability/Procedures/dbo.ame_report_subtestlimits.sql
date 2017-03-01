SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_report_subtestlimits]
-- Define input parameters
	@astation	char(20) = NULL -- ACS_Serial
-- Define code
AS
declare @testname char(20)

select @testname = TestName from stations where station_name=@astation


if @testname = 'BSCAN'
begin
if isnumeric(substring(@astation,len(@astation) -1,1)) =1
begin

		select  substring(@astation,1,len(@astation)-1), SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, OpportunitiesforFail   from SubTestLimits with(NOLOCK)
			where Station_Name=@TESTNAME
order by sap_model_name
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
                                     Note_ID, OpportunitiesforFail   from SubTestLimits 
			where Station_Name=@astation
order by sap_model_name
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=@astation+'1')
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, OpportunitiesforFail  from SubTestLimits 
			where Station_Name=@astation+'1'
order by sap_model_name
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1) )
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, OpportunitiesforFail  from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1)
order by sap_model_name
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1)+'1' )
	   begin
		select  Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, 
                                     strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, 
                                      Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, 
                                     Note_ID, OpportunitiesforFail  from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1)+'1'
order by sap_model_name
		return
	   end



-- Create the Stored Procedure
GO