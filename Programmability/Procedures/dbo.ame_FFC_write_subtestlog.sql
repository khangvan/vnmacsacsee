SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_FFC_write_subtestlog]
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
	@comment	char(80) = NULL -- Scanned component serial number
	
-- Define code
AS
      if not exists ( select test_id from subtestlog where test_id = @testid and subtest_name=@subname and station = @sname )
     begin
	Begin Transaction
		--Save into Bill's subtestfailures table
--		if @pass='F' 
--		  begin
--			insert into subtestfailures (Test_ID, subtest_Name)
--			values(@testid,@subname)
--		   end
		if @pass='F' 
		  begin
			insert into subtestfailures (Test_ID, subtest_Name)
			values(@testid,@subname)
		   end

		--Save new subtestlog db record
		Insert subtestlog
                          (
                              ACS_Serial,
                             Station,
                             SubTest_Name,
                             Test_ID,
                             Pass_Fail,
                             strValue,
                             intValue,
                             floatValue,
                             Units,
                             Comment
                          )
		Values(@aserial, @sname, @subname, @testid, @pass, @strval,
			@intval,@floatval,@units,@comment)
		if @@ERROR <> 0
		   begin
			--raiserror('E403.13 Serious Error. Failed to append record to assemblies db',17,1)
			Rollback Transaction
			return 12
		   end
	--Commit T-SQL transaction
	Commit Transaction
    end
GO