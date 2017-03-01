SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_get_BOM_Level_Station_v2 - NOT deployed]
-- Define input parameters
	@sname 		char(20) = NULL,
	@mname		char(20) = NULL,
	@testStn	int = 0 -- 0 is false(use part control) and 1 is true
-- Define code
AS
	set nocount on
	--Define local variable(s)
	declare @comment varchar(20)
	declare @scount int
	declare @mcount int
	declare @Today datetime

	set @Today=getdate()

	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror('1.0117',16,1)
			return
	   end
	if @mname is NULL
	   begin
		raiserror('1.1700',16,1)
		return
	   end

	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@sname and Status='A')
	   begin
		set @comment = ltrim(rtrim(@sname))
		raiserror('1.1701',16,1)
		return
	   end

	--See if Part exists
	if not exists(select SAP_Count from Products 
		where SAP_Model_Name=@mname and Status='A')
	   begin
		exec ame_create_label_format @mname,'','A'

		--set @comment = ltrim(rtrim(@mname))
		--raiserror('1.1703 %s',16,1,@comment)
		--return
	   end

	-- Create output cursor
	-- if we're in prerelease mode then performat a left outer join with file name mapping file
	-- otherwise, the file name will be the SAME as the part number
	--if @acsmode = 1
	 -- begin
	 if @testStn = 0
	  begin 
--begin BOM override
--3-0504-12           

--good part #3-0530-16
--extra part #3-0530-02


--if @mname='PSI-1001-11100-106' and @sname='ACSP2DSCANNER'
 --  begin
--	update bom_level_station
--	set part_number='5-2361-03'
--	where part_number='5-2162-03' and sap_model='PSI-1001-11100-106' and station='ACSP2DSCANNER'
 --  end

-- Omega tech BOM kludge
if @sname='ViperOpticsLoad' and substring(@mname,1,3) in ('851','852','951','952','953')
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and substring(Part_Number,1,2)<>'5-'
	end

-- RFID BOM override
if @sname='ACS4410CASEBACK' and substring(@mname,1,3)='F50'
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-3626-02 '
	end


if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-16')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-14')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-12')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-10')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-08')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

--!#@$!#$@#$

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-16')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-14')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-12')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-10')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-08')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-22')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-24')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-26')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-34')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-24')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-06','3-0542-04','3-0542-02')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-06')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-04','3-0542-02')
  end




-- FFC BOM overrides
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1100', 'QS6-2100', 'QS6-4100', 'QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100','QS6-A110'))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1530')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100', 'QS6-3100','QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','666812-014001-0000','667015-020000-0000','668112-014001-0000','668415-019000-0000','668712-014006-0000',
'668815-019000-0000','669019-001001-0000','669019-001001-0203','669119-001018-0203','QS6-A110'))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

if @mname in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100', 'QS6-3100','QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','666812-014001-0000','667015-020000-0000','668112-014001-0000','668415-019000-0000','668712-014006-0000',
'668815-019000-0000','669019-001001-0000','669019-001001-0203','669119-001018-0203','QS6-A110')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

--- wkurth added 7/22


if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='664415-001005-0219')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('664415-001005-0000')
  end

-- end of wkurth added 7/22

-- or substring(@mname,1,2)='06'
		if substring(@mname,1,2)='PS'
			begin
				if exists(select Part_Number from BOM_Level_Station where Station=@sname and SAP_Model=@mname 
					and substring(Part_Number,1,6)='5-1915')
					begin
						delete BOM_Level_Station
						where Station=@sname and SAP_Model=@mname and
						    Part_Number in ('7-0768','3-0511-03','5-1107','5-1127','5-1221','5-1327','4-3207-01','4-3203-01',
							'4-3207-03','4-3203-03','4-3207-06','4-3203-02','4-3207-07','4-3207-12','4-3203-05')
					end
			end

	   select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
		BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
		Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
		Partlist.Automatic As Display_Option, 
		Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel 
		from Partlist Inner join Catalog
		on Partlist.Part_No = Catalog.Part_No_Count
		Inner join Stations on Partlist.Station = Stations.Station_Count
		Inner join BOM_Level_Station on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
		Left Outer Join MappedFileNames on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
		where Stations.Station_Name=@sname and BOM_Level_Station.Station=@sname and 
			BOM_Level_Station.SAP_Model = @mname 
		Order by Catalog.Part_No_Name
		return
	  end
	else -- we have a test station
	 begin

		--if substring(@mname,1,3)='202' or substring(@mname,1,3)='203' or substring(@mname,1,3)='204'
		 --  begin
			--update BOM
				--set Part_Number = 'X96-6311',bom.description ='CONFIG'
				--where Part_Number='2304-0234' and SAP_Model=@mname
		   --end
		
	--	if  (substring(@mname,1,3)='202')or(substring(@mname,1,3) = '203')or(substring(@mname,1,3) = '204')
		--	or(@mname='3-0504-02')or(@mname='3-0508-02')
		 --  begin
			--update BOM
			--	set Part_Number = 'R96-5168'
				--where Part_Number='R96-6341' and SAP_Model=@mname
		  -- end
		--if @mname='09501-0433-08010A' or @mname='3-0439-04'
		  -- begin
			--update BOM
			  -- set Part_Number='R96-6570'
			   --where Part_Number='R96-6430' and SAP_Model=@mname
		   --end

--begin BOM override
--if @Today<'4-1-2004 23:59:00'
--	begin
	--	update BOM_Level_Station
	--		set Part_Number='R96-XXXX'
	--		where Part_Number='R96-7106'
	--end


--begin BOM override
--if substring(@mname,1,3)='5-1' or substring(@mname,1,2)='3-'
--if @mname='09401-02112-05012A'
--begin
  -- update BOM
   --set Part_Number='3-0548-02'
     -- where Part_Number='3-0508-08'

--   update BOM
--   set Part_Number='R96-6784'
 --     where Part_Number='R96-6722'

--end
--brutus base station override
if @sname='BRUTUSBASE'
   begin
	delete bom_level_station
	where part_number='R96-6445'
	 and station='BRUTUSBASE'
   end
-- HERE!
-- wk
if @sname in ( 'RhinoFulFillment1' , 'RhinoFulFillment2', 'RhinoFulFillment3')
begin
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and (Part_Number in
 ('5-1827-10', '5-1827-12','5-1828-10','5-1828-12')))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0581-02')
  end
end
-- end wk

	   	select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
			Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
			Partlist.Automatic As Display_Option, 
			Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel 
			from Partlist Inner join Catalog
			on Partlist.Part_No = Catalog.Part_No_Count
			Inner join Stations on Partlist.Station = Stations.Station_Count
			Inner join BOM_Level_Station on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
			Left Outer Join MappedFileNames on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
			where Stations.Station_Name=@sname AND bom_level_station.Station=@sname and
				BOM_Level_Station.SAP_Model = @mname 
		union
		select BOM_Level_Station.SAP_Model,BOM_Level_Station.Part_Number,BOM_Level_Station.Rev,BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, 'Station' as Station,
			'X' as Part_Type, BOM_Level_Station.ACSEEMode, 
			'A' as Display_Option, '1' as Display_Order,MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel 
			 from BOM_Level_Station
			Left Outer Join MappedFileNames on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number 
			where BOM_Level_Station.Station=@sname and BOM_Level_Station.SAP_Model = @mname and (  substring(BOM_Level_Station.Part_Number,1,3) = 'R96' 
			or substring(BOM_Level_Station.Part_Number,1,4) = 'INFO' 
			or substring(BOM_Level_Station.Part_Number,1,3) = 'ERS'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'R56'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XBL'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'X96'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'eb'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'nk'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XVA'  )
		return
	 end


/*
	   select BOM.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM.Rev, BOM.Description,
		BOM.BOM_Date_Time, Stations.Station_Name As Station,
		Partlist.Get_Serial As Part_Type, BOM.ACSEEMode, 
		Partlist.Automatic As Display_Option, 
		Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName 
		from Partlist Inner join Catalog
		on Partlist.Part_No = Catalog.Part_No_Count
		Inner join Stations on Partlist.Station = Stations.Station_Count
		Inner join BOM on BOM.Part_Number = Catalog.Part_No_Name
		Left Outer Join MappedFileNames on BOM.Part_Number = MappedFileNames.Part_Number
		where Stations.Station_Name=@sname AND BOM.SAP_Model = @mname 
		Order by Catalog.Part_No_Name
		return
*/

-- Create the Stored Procedure
GO