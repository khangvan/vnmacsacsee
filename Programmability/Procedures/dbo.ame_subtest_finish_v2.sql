SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE proc [dbo].[ame_subtest_finish_v2]
-- Define input parameters
	@aserial	char(20) = NULL, -- ACS_Serial
	@sname		char(20) = NULL, -- Station_Name (from Stations db)
	@subname	char(30) = NULL, -- Scanned component serial number
	@testid		char(50) = NULL, -- Scanned component serial number
	@Pass		char(3) = NULL, -- Scanned component serial number
	@strval		char(20) = NULL, -- Scanned component serial number
	@intval		int = NULL, -- Scanned component serial number
	@floatval	real = NULL, -- Scanned component serial number
	@units		char(30) = NULL, -- Scanned component serial number
	@comment	char(80) = NULL, -- Scanned component serial number
	@stlid                 int OUTPUT
-- Define code
AS
	set @stlid = -1 
	--Verify that non-NULLable parameter(s) have values
	if @aserial is NULL
	   begin
		 --raiserror ('E403.1 Illegal Parameter Value. You must specify an ACS Serial Number.',
			--16,1) with nowait
		return 2
	   end
	if @sname is NULL
	   begin
		--raiserror ('E403.4 Illegal Parameter Value. You must specify a station name.',
			--16,1) with nowait
		return 4
	   end

	Begin Transaction
		--Save into Bill's subtestfailures table
		if @pass='F' 
		  begin
			insert into subtestfailures (Test_ID, subtest_Name)
			values(@testid,@subname)
		   end

		--Save new subtestlog db record
		Insert subtestlog ( ACS_Serial, Station, SubTest_Name, Test_ID, Pass_Fail, strValue, intValue, floatValue, Units, Comment )
		Values(@aserial, @sname, @subname, @testid, @pass, @strval,
			@intval,@floatval,@units,@comment)
                          set @stlid = scope_identity()
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
	--Commit T-SQL transaction
	Commit Transaction
	return 1
-- Create the Stored Procedure
GO