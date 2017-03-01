SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[sp_report_subtestlimits]
-- Define input parameters
	@astation	char(20) = NULL -- ACS_Serial
-- Define code
AS

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
		select * from SubTestLimits 
			where Station_Name=@astation
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=@astation+'1')
	   begin
		select * from SubTestLimits 
			where Station_Name=@astation+'1'
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1) )
	   begin
		select * from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1)
		return
	   end

	--See if Station already exists
	if exists(select SAP_Model_Name from SubTestLimits 
		where Station_Name=substring(@astation,1,len(@astation)-1)+'1' )
	   begin
		select * from SubTestLimits 
			where Station_Name=substring(@astation,1,len(@astation)-1)+'1'
		return
	   end



-- Create the Stored Procedure
GO