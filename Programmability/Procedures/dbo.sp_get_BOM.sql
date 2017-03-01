SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[sp_get_BOM]
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
		set @comment = ltrim(rtrim(@mname))
		raiserror('1.1703 %s',16,1,@comment)
		return
	   end

	-- Create output cursor
	-- if we're in prerelease mode then performat a left outer join with file name mapping file
	-- otherwise, the file name will be the SAME as the part number
	--if @acsmode = 1
	 -- begin
	 if @testStn = 0
	  begin 
		if substring(@mname,1,2)='PS' or substring(@mname,1,2)='06'
			begin
				if exists(select Part_Number from BOM where SAP_Model=@mname and substring(Part_Number,1,6)='5-1915')
					begin
						delete BOM
						where SAP_Model=@mname and
						    Part_Number in ('7-0768','3-0511-03','5-1107','5-1127','5-1221','5-1327','4-3207-01','4-3203-01',
							'4-3207-03','4-3203-03','4-3207-06','4-3203-02','4-3207-07','4-3207-12','4-3203-05')
					end
			end

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
		union
		select BOM.SAP_Model,BOM.Part_Number,BOM.Rev,BOM.Description,
			BOM.BOM_Date_Time, 'Station' as Station,
			'X' as Part_Type, BOM.ACSEEMode, 
			'A' as Display_Option, '1' as Display_Order,MappedFileNames.MappedFileName
			 from BOM
			Left Outer Join MappedFileNames on BOM.Part_Number = MappedFileNames.Part_Number 
			where BOM.SAP_Model = @mname and (  substring(BOM.Part_Number,1,3) = 'R96' 
			or substring(BOM.Part_Number,1,4) = 'INFO' 
			or substring(BOM.Part_Number,1,3) = 'ERS'
			or substring(BOM.Part_Number,1,3) = 'R56'
			or substring(BOM.Part_Number,1,3) = 'XBL'
			or substring(BOM.Part_Number,1,3) = 'X96'
			or substring(BOM.Part_Number,1,2) = 'eb'
			or substring(BOM.Part_Number,1,2) = 'nk'
			or substring(BOM.Part_Number,1,3) = 'XVA'  )

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