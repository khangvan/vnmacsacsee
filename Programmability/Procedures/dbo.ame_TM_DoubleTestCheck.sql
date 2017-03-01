SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TM_DoubleTestCheck]
@ACS_Serial		char(20) = NULL, 	-- ACS_Serial
@SapModel		char(20) = NULL, 	-- Sap Model
@StationName	char(20) = NULL, 	-- Station Name 
@TestID			char(50) = NULL,	-- Test ID
@ThisResult		char(3) = NULL 	-- Test Result (P or F)

AS
set nocount on

declare @SubTest char(30)
declare @Station char(20)

declare @TotalResult int

declare @retv int

set @TotalResult = 1 -- True
set @Station = ''
set @SubTest = ''



-- all parameter are not nullable
if @ACS_Serial is null or @SapModel is null or @StationName is null or @TestID is null or @ThisResult is null
begin 
	print /*select*/ 'One or more parameter is null'
	return 0
end


set @TotalResult=1 -- True
-- look for an entry into double test table

if (select max (dt_id) from [ACS EE].[dbo].TM_DoubleTestTable where dt_model=@SapModel) is not null
begin
	-- this model has two final test
	print /*select*/ 'This base model has two final tests'
	
	declare TMTEST_RESULTS cursor local scroll
	for
		select distinct dt_subtest
		from [ACS EE].[dbo].TM_DoubleTestTable 
		where dt_model=ltrim(rtrim(@SapModel)) 
		order by 1;
	
	open TMTEST_RESULTS
	
	fetch first from TMTEST_RESULTS into @SubTest
	
	while (@@FETCH_STATUS=0)
	begin
		print /*select*/ 'Looking for Station '+@Station
		
		if (select dt_station from [ACS EE].[dbo].TM_DoubleTestTable where dt_model=@SapModel and dt_subtest=@subtest and dt_station=@StationName) is not null
		begin
			print /*select*/ 'It is this Station '
			-- I have already the result in this SP I don't need to retrieve it from database
			if (rtrim(@ThisResult)='F') -- only FAIL can change the status
			begin
				print /*select*/ 'Result Fail'
				set @TotalResult=0
			end
		end
		else
		begin
			-- I have to retrieve the result from testlog
			print /*select*/ 'Retrieve Result '
			exec @retv =  ame_TM_Previous_Test_Verification_New @ACS_Serial, @SubTest
			
			if (@retv <2)
			begin
				print /*select*/ 'Not Tested or Failed'
				set @TotalResult=0
			end
			else -- means not tested 
			begin
				print /*select*/ 'Tested'			
			end
		end
		fetch next from TMTEST_RESULTS into @SubTest
	end
	
	close TMTEST_RESULTS
	deallocate TMTEST_RESULTS
end
else
begin
	print /*select*/ 'This base model has only one final test'	
	if rtrim(@ThisResult)='F'
	begin
		set @TotalResult=0
	end
end

return @TotalResult;
GO