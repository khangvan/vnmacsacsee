SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


















CREATE			  proc [dbo].[ame_get_BOM_Level_Station]
-- Define input parameters
	@sname 		char(20) = NULL,
	@mname		char(20) = NULL,
	@testStn	int = 0, -- 0 is false(use part control) and 1 is true
              @ProdOrder nchar(20) = '' -- 0 is false(use part control) and 1 is true
-- Define code
AS
	set nocount on
	--Define local variable(s)
	declare @comment varchar(20)
	declare @scount int
	declare @mcount int
	declare @Today datetime

             declare @holdbomlevelstation table (
	[Station] [nchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[SAP_Model] [nchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Part_Number] [nchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[Rev] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[Description] [nchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[BOM_Date_Time] [smalldatetime] NULL ,
	[ACSEEMode] [int] NULL ,
	[Qnty] [int] NULL ,
	[BOMLevel] [int] NULL ,
             [Part_type] [nchar](5),
             [ProdOrder] [nchar](20)
              )

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
	if not exists(select SAP_Count from Products  with(NOLOCK)
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
/*** taken out for VIPEROPTICS parts from VPOMEGAFINISH
if @sname='ViperOpticsLoad' and substring(@mname,1,3) in ('851','852','951','952','953')
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and substring(Part_Number,1,2)<>'5-'
	end
*/


-- wk prepared to add on 1/24/2012 per Doug Sustaire request
-- removed per andy palmer on 2/72/012
/*
if @sname='VIPERPLATTER'
begin
   if @mname in ('868157201-0005020R','868158201-0023010R','868155201-0105020R')
   begin
           if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='5-6539' )
           begin
                  update BOM_Level_Station set Part_Number = '5-3451' 
                        where  Station=@sname and SAP_Model=@mname and Part_Number='5-6539' 
           end
   end
end
*/
/*
--temporary fix ECP7450
if exists (select Part_Number from BOM_Level_Station where station='ACSVNDALIMODST' and sap_model=@mname and part_number='663102030')
begin
	update BOM_Level_Station set Part_Number='3-0998-06' where station='ACSVNDALIMODST' and sap_model=@mname and part_number='663102030'
end
if exists (select Part_Number from BOM_Level_Station where station='ACSVNDALIMODST' and sap_model=@mname and part_number='663102020')
begin
	update BOM_Level_Station set Part_Number='663102010' where station='ACSVNDALIMODST' and sap_model=@mname and part_number='663102020'
end
*/
----khang add Apr 11
--if exists (select Part_Number from BOM_Level_Station where (Station='ACSVNCOLENGONE' and Part_Number='700005220'))
	
--begin
--	update BOM_Level_Station set Part_Number='700005202' where (Station='ACSVNCOLENGONE' and Part_Number='700005220')
--END

--Huy 15/Jun for JOYA at ACSVNTWOSTART, remove 740045100 out of BOM
--kvan add more product
if exists (select Part_Number from BOM_Level_Station where (Station='ACSVNTWOSTART' and Part_Number='740045100' 
	and (SAP_Model like '70026050[012]%' or SAP_Model like '70026060[012]%') ))
begin
	delete BOM_Level_Station where (Station='ACSVNTWOSTART' and Part_Number='740045100' 
		and (SAP_Model like '70026050[012]%' or SAP_Model like '70026060[012]%'))
END
--end Huy 15/Jun

/*-- Kvan add for  740049301 , change tepm 700058102 (new) to 700058101
if exists (
    select * from bom_level_station where sap_model ='740049301' and part_number ='700058102'
    )
    begin
    update bom_level_station
    set part_number ='700058101'
    where sap_model ='740049301' and part_number ='700058102'

    end

-- Kvan--end*/

--khang add  08 May 2016
if exists (select Part_Number from BOM_Level_Station where (Station='ACSVNCOLENGONE' and Part_Number='700005202'))
	
begin
	update BOM_Level_Station set Part_Number='700005220' where (Station='ACSVNCOLENGONE' and Part_Number='700005202')
END

-- SUB-ASSY 700101701: delete 663223016 and 683223010 at ACSVNMPMODST
if exists (select Part_Number from BOM_Level_Station where (Station='ACSVNMPMODST' and SAP_Model='700101701' and 
	(Part_Number='663223016' or Part_Number='683223010')))
begin
	DELETE BOM_Level_Station WHERE  (Station='ACSVNMPMODST' and SAP_Model='700101701' and 
	(Part_Number='663223016' or Part_Number='683223010'))
END

-- SUB-ASSY 700257100: delete 662907012 at ACSVNCOLENGONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLENGONE' and SAP_Model='700257100' and Part_Number='662907012')
begin
	DELETE BOM_Level_Station WHERE Station='ACSVNCOLENGONE' and SAP_Model='700257100' and Part_Number='662907012'
END

-- FRU 700119100: add board 700119100 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700119100')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700119100' and SAP_Model='700119100')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700119100'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY MOUNT SCAN ENGINE, 5V,G2D SB5490'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700119100' and part_number='INFO'
	end
END

-- FRU 700091701: add board 700091701 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700091701')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700091701' and SAP_Model='700091701')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700091701'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY, MOUNT SCAN ENGINE GRYPHON DPM'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700091701' and part_number='INFO'
	end
END

---- FRU 700005301: add board 700005301 at ACSVNCOLBASEONE
--if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700005301')
--begin
--	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700005301' and SAP_Model='700005301')
--	begin
--		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
--			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700005301'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY MOUNT SCAN ENGINE STD BT'),
--			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
--			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700005301' and part_number='700005202'
--	end
--end

-- FRU 700005302: add board 700005302 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700005302')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700005302' and SAP_Model='700005302')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			
			select Station, SAP_Model, '700005302', 'X0', 'ASSY MOUNT SCAN ENGINE,HD,BT', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
			BOM_Level_Station from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700005302' and part_number='INFO'
	end
end

-- FRU 700058100: add board 700058100 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700058100')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700058100' and SAP_Model='700058100')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700058100'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY MOUNT SCAN ENGINE STD 4-14V'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700058100' and part_number='700005202'
	end
end

-- FRU 700058102: add board 700058100 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700058102')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700058102' and SAP_Model='700058102')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700058102'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY MOUNT SCAN ENGINE STD 4-14V'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700058102' and part_number='700005220'
	end
end

-- FRU 700058201: add board 700058201 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700058201')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700058201' and SAP_Model='700058201')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700058201'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY MOUNT SCAN ENGINE HD 5V GD2'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700058201' and part_number='700005201'
	end
end

---- FRU 700058301: add board 700058100 at ACSVNCOLBASEONE
--if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700058301')
--begin
--	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700058301' and SAP_Model='700058301')
--	begin
--		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
--			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700058301'),Replace(Rev,Rev,'X0'),Replace(Description,Description,' ASSY MOUNT SCAN ENGINE,STD 5V, G2D'),
--			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
--			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700058301' and part_number='700005202'
--	end
--end


-- FRU 890002723: add board 700089200 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700089200')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700089200' and SAP_Model='700089200')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700089200'),Replace(Rev,Rev,'X0'),Replace(Description,Description,' ASSY MOUNT SCAN ENGINE,STD 5V, G2D'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700089200' and part_number='700005202'
	end
end

-- FRU 700016601: add board 700016601 at ACSVNCOLBASEONE
if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='700016601')
begin
	if not exists (select Part_Number from BOM_Level_Station where Part_Number='700016601' and SAP_Model='700016601')
	begin
		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
			select Station,SAP_Model,Replace(Part_Number,Part_Number,'700016601'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY,MOUNT SCAN ENG,GM4400-XX-433'),
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700016601' and part_number='700005202'
	end
end

-- FRU 740025800: add board 740025800 at ACSVNCOLBASEONE - khang change to info part 9 May
--if exists (select Part_Number from BOM_Level_Station where Station='ACSVNCOLBASEONE' and SAP_Model='740025800')
--begin
--	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='740025800' /*and part_number='INFO'*/)
--	begin
--		insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
--			select Station,SAP_Model,Replace(Part_Number,Part_Number,'740025800'),Replace(Rev,Rev,'X0'),Replace(Description,Description,'ASSY,MOUNT SCAN ENG,GM4400-XX-910'),
--			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Replace(Part_Type,Part_Type,''),ProdOrder
--			from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='740025800' --and part_number='INFO'
--	end
--end

--kvan fru 
	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='740025800' and part_number='740025800')
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, '740025800', '740025800', Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model='740025800' AND part_number ='INFO'
	end

--kvan fru 890000285
DECLARE @FRUENGINE nchar(30) = '700016601'

	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model='700016601' and part_number='700016601')
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, '700016601', '700016601', Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model='700016601' AND part_number ='INFO'
	end

-- 


--kvan fru 890000285
DECLARE @FRUENGINE1 varchar(30) = '700016601'

	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

	
	--kvan fru 890000063-700005301
 set @FRUENGINE1  = '700005301'

	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	end
	--FRU
	--FRU 890000065
set @FRUENGINE1 = '700058100'

	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END



	set @FRUENGINE1 = '700058301'

	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	-- FRU ENGINE-
	set @FRUENGINE1 = '700058201'
	if not exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLBASEONE' and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station='ACSVNCOLBASEONE' and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	-- FRU ENGINE -End

		-- FRU ENGINE-
		DECLARE @BASEST varchar(30), @FFCST varchar(30)
		
	set @FRUENGINE1 = '890000063'
	SET @BASEST='ACSVNCOLBASEONE'
	SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

	-- FRU ENGINE -End
	
	set @FRUENGINE1 = '700005310'
	SET @BASEST='ACSVNCOLBASEONE'
	

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END


	-- FRU ENGINE -End
		
	set @FRUENGINE1 = '890000064'
	SET @BASEST='ACSVNCOLBASEONE'
	SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

--890003978           PART GD4410,I/F EL ASSY,STD, 4-14V REL2
	set @FRUENGINE1 = '700058101'
	SET @BASEST='ACSVNCOLBASEONE'
	

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	--if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	--begin
	--	INSERT INTO bom_level_Station
	--	(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
	--	select 
	--	Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
	--	 from BOM_Level_Station 
	--	where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	--END
--890003980           PART,GD4430 I/F ELECT ASSY, STD, 5V REL2
	set @FRUENGINE1 = '700058203' --890003980
	SET @BASEST='ACSVNCOLBASEONE'
	--SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

	set @FRUENGINE1 = '700016610' --890003980
	SET @BASEST='ACSVNCOLBASEONE'
	--SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

	set @FRUENGINE1 = '700058202' --890003980
	SET @BASEST='ACSVNCOLBASEONE'
	--SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	--if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	--begin
	--	INSERT INTO bom_level_Station
	--	(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
	--	select 
	--	Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
	--	 from BOM_Level_Station 
	--	where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	--END
--890004036           PART, GBT44 I/F ELEC ASSY, STD REL 2
	set @FRUENGINE1 = '700005308'--'890004036' - kvan 27 June
	SET @BASEST='ACSVNCOLBASEONE'
	--SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	--if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	--begin
	--	INSERT INTO bom_level_Station
	--	(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
	--	select 
	--	Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
	--	 from BOM_Level_Station 
	--	where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	--END

--890003979           PART,GD4430, I/F ELEC ASSY, HD,5V REL2
	set @FRUENGINE1 = '890003979'
	SET @BASEST='ACSVNCOLBASEONE'
	SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
--890004037           PART, GBT44 I/F ELEC ASSY, HD REL 2
	set @FRUENGINE1 = '890004037'
	SET @BASEST='ACSVNCOLBASEONE'
	SET @FFCST='ACSVNONESTART'

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END
	if not exists (select Part_Number from BOM_Level_Station where station=@FFCST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@FFCST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END


	--890004039           
	set @FRUENGINE1 = '700261610'
	SET @BASEST='ACSVNCOLBASEONE'
	

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END

		--890002723            
	set @FRUENGINE1 = '700089200'
	SET @BASEST='ACSVNCOLBASEONE'
	

	if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select 
		Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station 
		where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	END



	-------- kvan fru loop
	--IF OBJECT_ID('tempdb..##cteTableManualContrl') IS NOT NULL
 --    /*Then it exists*/ DROP TABLE ##cteTableManualContrl
	--;WITH cteTableManualContrl AS
	--(
	--SELECT 
	--ROW_NUMBER()OVER( ORDER BY sap_model  )As RowNum, sap_model,PartnumberOriginal
	-- FROM bomoverridesmcontrol  WHERE changetype ='RepeatedPart'
	-- )
	-- SELECT *  INTO 
	-- -- select * from 
	-- ##cteTableManualContrl from cteTableManualContrl

	       
 --     declare @PartChange2SAPModel nchar(20);
      
 --     DECLARE contacts_cursor CURSOR FOR
 --     select ##cteTableManualContrl.PartnumberOriginal from 
	-- ##cteTableManualContrl
      
 --     OPEN contacts_cursor;
 --     FETCH NEXT FROM contacts_cursor;
      
 --     WHILE @@FETCH_STATUS = 0
 --        BEGIN
 --           FETCH NEXT FROM contacts_cursor into @PartChange2SAPModel
 --     	 print @PartChange2SAPModel
 --          -- PRINT 'Inside WHILE LOOP on TechOnTheNet.com';

	--	 /*do as fru*/
	--	 IF  (@mname =@PartChange2SAPModel)
	--	 BEGIN
	--	 	set @FRUENGINE1 = @PartChange2SAPModel
	--		 SET @BASEST='ACSVNCOLBASEONE'
	

	--if not exists (select Part_Number from BOM_Level_Station where station=@BASEST and sap_model=@FRUENGINE1 and part_number=@FRUENGINE1)
	--begin
	--	INSERT INTO bom_level_Station
	--	(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
	--	select 
	--	Station, @FRUENGINE1, @FRUENGINE1, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
	--	 from BOM_Level_Station 
	--	where Station=@BASEST and SAP_Model=@FRUENGINE1 AND part_number ='INFO'
	--END
	--end
 --        END;
 --     --PRINT 'Done';
      
 --     CLOSE contacts_cursor;
 --     DEALLOCATE contacts_cursor;
	-- IF OBJECT_ID('tempdb..##cteTableManualContrl') IS NOT NULL
 --    /*Then it exists*/ DROP TABLE ##cteTableManualContrl
      
	






-- PS71XX Base 740000100 - Add box label 731062200
if not exists (select Part_Number from BOM_Level_Station where Station='ACSVNFFCDALIBOX' and Part_Number='731062200' and SAP_Model='740000100')
begin
	insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
		select Station,SAP_Model,Replace(Part_Number,Part_Number,'731062200'),Replace(Rev,Rev,'X0'),Description,
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder
			from BOM_Level_Station where station='ACSVNFFCDALIBOX' and Part_Number='731062400' and SAP_Model='740000100'
	insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
		select Station,SAP_Model,Replace(Part_Number,Part_Number,'731062200'),Replace(Rev,Rev,'X0'),Description,
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder
			from BOM_Level_Station where station='ACSVNFFCDALIBOX' and Part_Number='731168500' and SAP_Model='740000100'
end

-- PS71XX Base 199000329 - Add box label 731062200
if not exists (select Part_Number from BOM_Level_Station where Station='ACSVNFFCDALIBOX' and Part_Number='731062200' and SAP_Model='199000329')
begin
	insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
		select Station,SAP_Model,Replace(Part_Number,Part_Number,'731062200'),Replace(Rev,Rev,'X0'),Description,
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder
			from BOM_Level_Station where station='ACSVNFFCDALIBOX' and Part_Number='731062300' and SAP_Model='199000329'
	insert BOM_Level_Station (Station,SAP_Model,Part_Number,Rev,Description,BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder)
		select Station,SAP_Model,Replace(Part_Number,Part_Number,'731062200'),Replace(Rev,Rev,'X0'),Description,
			BOM_Date_Time,ACSEEMode,Qnty,BOMLevel,Part_Type,ProdOrder
			from BOM_Level_Station where station='ACSVNFFCDALIBOX' and Part_Number='731168400' and SAP_Model='199000329'
end

-- wk added on 9/8/2014 per Tri Request
if @sname='ACSVNMAREMOTE' and @mname  = '5-3482-01'
begin
           if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='5-3384-01' )
           begin
                  delete BOM_Level_Station  
                        where  Station=@sname and SAP_Model=@mname and Part_Number='5-3384-01' 
           end
end

-- wk added on 1/16/2009 per Carl Canavan request
if @sname = 'ACSHUYPLATTER'
begin
   if ( @mname like '8[3-4]__22%') OR ( @mname like '8[3-4]__24%') OR ( @mname like '8[3-4]__26%') OR ( @mname like '8[3-4]__32%') OR
       ( @mname like '8[3-4]__34%') OR ( @mname like '8[3-4]__36%') OR ( @mname like '8[3-4]__48%') OR ( @mname like '8[3-4]__50%') OR
       ( @mname like '8[3-4]__52%') OR ( @mname like '8[3-4]__54%') 
   begin
       if exists ( select part_number from BOM_Level_Station where station = @sname and SAP_Model = @mname and
                                 part_number in ('5-3171-01','5-3171-02','5-3171-03','5-3170-01','5-3170-02','5-3170-03'))
             begin
                 delete from BOM_Level_Station where station = @sname and SAP_Model = @mname  and part_number = '4-4592'
             end
   end
end



-- removed on 11/11/2009 per Racinda Adams request
/*
-- added on 11/10/2009 per Racinda Adams request
if @sname='ACSDALISTART' and @mname  = '5-3357'
begin
           if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='3-0998-10' )
           begin
                  update BOM_Level_Station set Part_Number = '3-0998-04' 
                        where  Station=@sname and SAP_Model=@mname and Part_Number='3-0998-10' 
           end
end

-- added on 11/10/2009 per Racinda Adams request
if @sname='ACSQD2100START' and @mname  = '5-3350'
begin
           if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='3-0998-10' )
           begin
                  update BOM_Level_Station set Part_Number = '3-0998-04' 
                        where  Station=@sname and SAP_Model=@mname and Part_Number='3-0998-10' 
           end
end
*/

-- wdk added on 9/2/2008 per C Fleming request
if @sname='VIPEROPTICSLOAD' and @mname  = '85106-0412-0800D'
begin
           if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='3-0847-02' )
           begin
                  update BOM_Level_Station set Part_Number = '3-0847-44' 
                        where  Station=@sname and SAP_Model=@mname and Part_Number='3-0847-02' 
           end

end

-- emergency bom override til SAP bom pull RFC issue solved.
--if @sname='ACSMALABEL' and @mname='84215403-101140000'
--           begin
--                  update BOM_Level_Station set Part_Number = '5-3214' 
--                        where  Station=@sname and SAP_Model=@mname and Part_Number='5-3385' 

--           end


-- wdk added on 11/6/2009 per Jo Holthe request
-- removed per Jo Holthe request on 11/10/2009
--if ( @sname = 'ACSDALISTART' and  @mname = '5-3356' )
--begin
--   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '3-0998-06')
--end


-- wdk added on 11/02/2010 per Carl Canavan request
if ( @sname = 'ACSMALABEL' and @mname in ('847F2404-2024A1081'))
begin
                        insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,part_type )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, part_type
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel , part_type )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, part_type
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'
  
                            insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel , part_type )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, part_type
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'
               
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'

end


-- wdk added on 4/20/2011 per Carl Canavan request
if ( @sname = 'ACSMALABEL' and @mname in ('83213402-005','83213603-005','83213603-005130200','83212402-102140200','83215003-101140202', '84212603-102130200','83215405-C13A10800'))
begin
    if exists ( select Part_Type from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='731220900' )
    begin
      update BOM_Level_Station  set Part_Type = 'N' where Station=@sname and SAP_Model=@mname and Part_Number='731220900'
    end
end


-- wdk added on 11/02/2010 per Carl Canavan request
if ( @sname='ACSMALABEL' and @mname in ('847F2404-2024A1081'  ,  '84222404-D10030201'))
begin 
                        insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'
                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

end


-- wdk added on 11/30/2010 per Carl Canavan request
if ( @sname = 'ACSHUYPLATTER' and  (@mname  in  (   '83213603-005','84213603-101130200')))
begin
   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '4-4592')
end

-- wdk added on 8/27/2010 per Carl Canavan request
if ( @sname = 'ACSHUYPLATTER' and  @mname = '84215403-102050200' )
begin
   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '4-4592')
end


-- wdk added on 9/10/2008 per Brian request
if ( @sname = 'VIPEROPTICSLOAD' and  @mname = '85106-0412-08000D' )
begin
   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '3-0847-02')
end

-- wdk 01/30/2006  - for R. Weston
if ( @sname = 'ACSDOCKSTART' and  @mname = '7-0858' )
begin
   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '4-3926-01')
end

-- RFID BOM override
if @sname='ACS4410CASEBACK' and substring(@mname,1,3)='F50'
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-3626-02'
	end
-- added by W Kurth per Larry Smith request
if @sname='ACSMALABEL' and ( substring(@mname,1,3)='836'  or substring(@mname,1,3)='846' )
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-3385'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-3386'
	end

if @sname='ACSMASTART' and @mname='81104-1343-001140H'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-08'
           end

-- added by W Kurth on 5/19/2009 per Doug S request
if @sname='ACSREMDPLYSTART' and @mname='5-3386'
           begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='8-0763-10'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0763-10'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='8-0763-10'
                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='8-0763-10'

           end


-- added by W. Kurth on 5/24/2010 per Carl Canavan request
 if @sname='FUL2PACKAGE' and @mname  in (  'MG110041-005-413B')
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= '4-4344-01'
           end



if @sname='FUL3LABEL' and @mname='MG110041-005-413B'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-02'
           end

-- added by W. Kurth on 5/17/2010 per Zach Dodson request
if @sname='ACSMALABEL' and  ( @mname = '84222404-D10030201' )
begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,Part_Type, ProdOrder )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'


                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel ,Part_Type, ProdOrder )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,Part_Type, ProdOrder
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'

		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='4-3819-01'





                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,Part_Type, ProdOrder )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,Part_Type, ProdOrder
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel ,Part_Type, ProdOrder )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel,Part_Type, ProdOrder
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

end


if @sname='ACSMAREMOTE' and  ( @mname = '5-3439' )
begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'


                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'




                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1464'


                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1464'

		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1464'



-- added on 4/19/2011 by W Kurth per Doug S request

                        insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'

		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='5-2809'
end






-- added by W Kurth on 9/15/2009 per Doug S request
if @sname='ACSMALABEL' and  ( @mname like '854%' )
           begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

           end

-- added by W Kurth on 4/19/2011 per Doug S Request
-- modifed by W Kurth on 7/26 per Carl Canavan request
if @sname='ACSMALABEL' and  (( @mname like '847%' ) or ( @mname like '842%')) and (@mname != '847F2404-2024A1081')
           begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='199381901'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'
                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

           end
-- added/modifed by W Kurth on 7/26 per Carl Canavan request
if @sname='ACSMALABEL' and  (@mname = '847F2404-2024A1081')
begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='199381901'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

                         insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='199381901'

end




-- added by W Kurth on 5/19/2009 per Doug S request
if @sname='ACSREMDPLYSTART' and @mname='5-3386'
           begin
                         insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='4-4699-01'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4699-01'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='4-4699-01'
                   
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='4-4699-01'

           end


-- added by W Kurth on 2/14/2007 per Carl Canavan request
if @sname='ACSMASTART' and @mname='811021928-001040AR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-1506'
           end

-- added on 12/03/2008 per Magellen Tech(Brian) request
if @sname='ACSMASTART' and @mname='82213-0112-003022B'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'
           end


-- added on 4/15/2008 per magellan tech request

if @sname='ACSMASTART' and @mname='821110710-001000R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end

-- added on 6/17/2008 per Carl Canavan request

if @sname='ACSMASTART' and @mname in  ( '82219-0118-A04020A', '82212-0310-105022B')
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'
           end
-- added on 2/12/2009 per Carl Canavan request

-- added on 2/4/2009 by W Kurth per Jo Holthe request
if @sname='ACSEEFUL2' and @mname  = 'QS65B-3140102-401R'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'

end


-- added on 11/02/2009 per Jo Holthe request
if @sname='ACSEEFUL2' and @mname  = 'QS65B-3140002-401R'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-3430-02'

end

-- added on 9/8/2009 by W Kurth per Jo Holthe request
if @sname='ACSEEFUL2' and @mname  = 'QS65B-3662105-402R'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-3430-02'

end

-- added on 9/16/2009 by W Kurth per Carl Canavan request
if @sname='ACSEEFUL2' and @mname  = 'QS65B-3140102-401R'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-3430-02'

end


-- added on 2/4/2009 by W Kurth per Jo Holthe request
if @sname='ACSEEFUL2' and @mname  = 'PS71-2101000'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1432'

end

-- added on 1/3/2008 per Jo Holthe request
if @sname='FUL3LABEL' and @mname='MG103012-716-106R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-01'
           end

-- added on 7/13/2008 pre Carl Canavan request
 if @sname='FUL3LABEL' and @mname in ( '660660-001001-0204', '660260-001001-0201', '662460-001000-0204','QS6-2200-02','660260-001001-0229' )
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end

-- added on 6/17/2009 per Carl Canavan request
 if @sname='FUL2PACKAGE' and @mname  ='QS6-A200-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2802'
           end

-- added on 7/13/2008 pre Carl Canavan request
 if @sname='FUL2PACKAGE' and @mname  in (  '660260-001001-0201', 'QS6-2200-02' ,'660260-001001-0229')
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2671'
           end


-- added on 2/12/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end


-- added on 12/4/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='660360-132020-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end


-- added on 4/30/2009 per Jo Holthe request
if @sname='FUL3LABEL' and @mname='MG103042-016-411R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= '8-0681-01'
           end


-- added on 4/7/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='668215-101001-0700'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end


if @sname='FUL2PACKAGE' and @mname='668215-101001-0700'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end

-- added 6/11/2008 per carl canavan request
if @sname='FUL2PACKAGE' and @mname='660660-001001-0204'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end


-- added on 12/4/2008 per carl canavan request
if @sname='FUL2PACKAGE' and @mname='660360-132020-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end

if @sname='FUL3LABEL' and @mname='QS6-2200-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end


if @sname='FUL2PACKAGE' and @mname='QS6-2200-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end

-- added on 1/15/2009 by WK per Carl Canavan request
if @sname='ACSHUYPLATTER' and @mname='83215003-004140200'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4592'
           end


-- added on 4/24/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='QS6-2100-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end


-- added on 4/30/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='MG102041-015-412CR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-02'
           end

-- added on 2/18/2009 per Jo Holthe request
if @sname='ACSRCPACKAGE' and @mname in ('MG103042-016-411R','11-0160',
'MG10-3010-016-111',
'MG103010--016-111R',
'MG103012-016-106R',
'MG103012-016-111R',
'MG103012-716-106R',
'MG103012-716-111R',
'MG103021-016-202R',
'MG103042-016-411R',
'MG103042-016-412R'
)
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-01'
           end
/*
'11-0160',
'MG10-3010-016-111',
'MG103010--016-111R',
'MG103012-016-106R',
'MG103012-016-111R',
'MG103012-716-106R',
'MG103012-716-111R',
'MG103021-016-202R',
'MG103042-016-411R',
'MG103042-016-412R'
*/

if @sname='ACSRCPACKAGE' and @mname='MG102041-015-412CR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-02'
           end

-- added on 5/14/2008 per Carl Canavan request
if @sname='ACSEEFUL2' and @mname='07200101-0100-1105'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-1050-08'
           end


-- added on 5/22/2008 per Carl Canavan request

-- added on 5/1/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname in ( '668115-001001-0229', '669015-001001-0229' , 'QS6-2100-02' )
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2760'

           end

-- added on 12/5/2008 per carl canavan request
if @sname='FUL3LABEL' and @mname='660360-101020-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end

-- added on 12/5/2008 per carl canavan request
if @sname='FUL2PACKAGE' and @mname='660360-101020-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end



if @sname='ACSRCPACKAGE' and @mname in ('668115-001001-0229' , '669015-001001-0229' , 'QS6-2100-02' )
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2760'
           end

-- added on 5/5/2008 per Carl Canavan request
if @sname='ACSPWPACKAGE' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
	
           end



-- added on 9/17/2008 by W Kurth per Carl Canavan request
if @sname='ACSRCPACKAGE' and @mname  = 'QS6-2200-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2760'
           end

-- added on 9/17/2008 by W Kurth per Carl Canavan request
if @sname='ACSPWPACKAGE' and @mname='QS6-2200-01'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2802'

           end



if @sname='FUL2PACKAGE' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end

-- added on 4/24/2008 per Michelle Roper request
/*
if @sname='FUL3LABEL' and substring(@mname,1,4)='QS6-' and len(@mname) = 8
        begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
          end

if @sname='FUL2PACKAGE' and substring(@mname,1,4)='QS6-' and len(@mname) = 8
        begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
          end
*/

-- added on 2/12/2008 per Carl Canavan request
if @sname='FUL2PACKAGE' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end



-- added on 2/15/08 per Brian request
if @sname='ACSMALABEL' and @mname='822020313-303041AR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'
           end


--added on 12/21/2007 from maria T. request
if @sname='ACSMALABEL' and @mname='822020714-303040HR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end

--added on 1/2/2008 from maria tapia request
if @sname='ACSMALABEL' and @mname='822020213-302031AR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end

-- added on 1/24/2008 from Brian request
if @sname='ACSMALABEL' and @mname='822020313-303041AR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end


-- added on 1/24/2008 from Brian request
if @sname='ACSMALABEL' and @mname='8520202310-03011DR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
           end



-- added on 1/30/2008 from Brian request
if @sname='ACSMALABEL' and @mname='85213-02314-01031D'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
           end



--added on 1/2/2008 from maria tapia request
if @sname='ACSMALABEL' and @mname='82202-0716-303040J'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end


--added on 1/4/2008 from maria tapia request
if @sname='ACSMALABEL' and @mname='822020313-301040R'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end

-- added on 12/17/2007 from magellan tech request
if @sname='ACSMALABEL' and @mname='822170410-303041JR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end
-- added on 1/21/2008 per Brian request
if @sname='ACSMALABEL' and( @mname in ( '82202-0716-301040J' , '812020313-201042R'  ))
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
           end

-- added on 12/7/2007 from magellan tech request
if @sname='ACSMALABEL' and @mname='8521302314-01031DR'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1452'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1452'
           end


-- added on 5/23/2008 per Carl Canavan request
if @sname='VIPEROPTICSLOAD' and @mname  = '85101-1012-09010'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0799-10'

end


-- added on 5/13/2008 per Carl Canavan request -- also added 2 models on 6/27 per Carl C request
if @sname='ACSEEFUL2' and @mname  in ( '668115-001001-0229', '668412-001000-0204', 'QS6-2100-01' )
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1432'

end


-- added on 2/28/2008 by W Kurth per Carl Canavan and Jo Holthe/Doug Sustaire
if @sname='ACSEEFUL2' and @mname  like 'MG10%'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'

end


-- added on 1/23/2009 by W Kurth per Jo Holthe request
if @sname='ACSEEFUL2' and @mname  = 'QS65B-3110003-109R'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'

end

-- added by W Kurth on 10/24/2007 by Carl Canavan request
if @sname='ACSMASTART' and @mname='822170410-303041JR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'
           end



-- added by W Kurth on 1/24/2008 by Carl Canavan request
if @sname='ACSMASTART' and @mname='82211-0112-101040'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'
           end


-- added 12/2/2007 by Carl Canavan request
if @sname='ACSMASTART' and @mname='811041343-001140HR'     
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0726-08'
           end


-- added by W Kurth on 10/25/2007 by Carl Canavan request
if @sname='ACSMASTART' and @mname='811040943-001140HR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0726-08'
           end


if @sname='ACSMASTART' and @mname='821100244-001040AR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end

-- added 12/6/2007 per request from Brian
if @sname='ACSMASTART' and @mname='82202-0716-305010J'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-1580'

           end


if @sname='ACSMALABEL' and @mname in ( '82202-0716-305010J','81202-1116-201040')
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-0214'

           end

-- added on 7/16/2008 per Brian request
if @sname='VIPERPLATTER' and @mname like '852%'
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'
                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

           end

-- added on 7/16/2008 per Brian request
if @sname='VIPERPLATTER' and  (   @mname like '851%'  or @mname like '951%'  or @mname like '852%' or @mname like '952%' or @mname like '853%'  or @mname like ' 854%'  or @mname like '954%' or @mname like  '955%' )
           begin
 
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-0869'


           end


-- added on 7/16/2008 per Brian request
if @sname='VIPERUPPERSCANNER' and (  @mname like '852%' or @mname like '851%'  or @mname like '951%'  or @mname like '852%' or @mname like '952%' or @mname like '853%'  or @mname like ' 854%'  or @mname like '954%' or @mname like  '955%' )
           begin
                          insert into @holdbomlevelstation ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'


		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

                          insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

                         insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel  )
                          select top 1 Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel
                           from @holdbomlevelstation where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

                          
		delete from  @holdbomlevelstation   where  Station=@sname and SAP_Model=@mname and Part_Number='6-0869'

           end




-- added by W Kurth on 9/26/2007 per Ryan B request
--removed by R Mason on 8/6/2008 per Linda Martin
--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--           begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4586'
--           end

--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--           begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4719'
--           end


--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--           begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4585'
--           end


--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--           begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4609'
--           end


--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--           begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4582'
--           end


--if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
--          begin
--		delete BOM_Level_Station
--			where Station=@sname and SAP_Model=@mname and Part_Number='4-4583'
--           end



-- added by W Kurth on 8/1/2007 per brian o request
if @sname='ACSMASTART' and @mname='811021313-001140R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0726-08'
           end

-- added 12/19/2006 by wk per brent lingo
if @sname='ACSMASTART' and @mname='82112-0112-003020' and getdate() < '2/1/2007'
           begin
               update BOM_Level_Station set part_number='3-0542-28'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-28'

          end

-- added 12/20/2006 by wk per request from brent lingo
if @sname='ACSMASTART' and @mname='82101-0413-004022H' and getdate() < '2/1/2007'
           begin
               update BOM_Level_Station set part_number='3-0542-04'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'

          end

-- added 1/04/2007 by wk pre request from brent lingo
if @sname='ACSMASTART' and @mname in
(
'82105-1313-001040A' , '82105-0813-001040A', '82101-0810-001000' , '82105-0410-001000A' , '82105-1110-001000A' , '82105-0410-001000A'
)
 and getdate() < '2/1/2007'
           begin
               update BOM_Level_Station set part_number='3-0542-04'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'

          end

-- added 05/21/2007 by WK per request from Brian
if @sname='ACSMASTART' and @mname = '822060314-803050AR'

           begin
--               update BOM_Level_Station set part_number='3-0716-20'
--			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-02'


          end



if @sname='ACSMASTART' and @mname='81104-0943-001140H'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-08'
           end
-- added 11/20/2006 by Wkurth per brian request
if @sname='ACSMASTART' and @mname='82112-0112-003020'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end

-- added 11/14/2006 by WKurth per Brian request
if @sname='ACSMASTART' and @mname='821110753-004010AR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end

-- added 11/14/2006 by Wkurth per Brian requst
 if @sname='VIPEROPTICSLOAD' and @mname='95101-060012-0604'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0548-04'
           end


-- added 01/08/2008 per Jo Holthe request
 if @sname='ACSEEFUL2' and @mname='QS65B-3140002-401R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-2997-03'

	delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'

           end

-- added 02/05/2008 per Carl Canavan request
 if @sname='ACSEEFUL2' and @mname= 'QS65B-1140102-402R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='5-2997-01'

           end


-- added 12/19/2006 by WKurth per dave jordan, brent lingo request
if @sname='VIPEROPTICSLOAD' and @mname in
 ( '95207-020100-0502d' , '95208-020102-0302d' , '95308-020102-0302d', '95205-020110-0502d',
'95409-040120-0502A','95310-020102-0301H','95101-020012-0402A' ) and getdate() < '2/1/2007'
           begin
               update BOM_Level_Station set part_number='3-0504-02'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0848-02'

               update BOM_Level_Station set part_number='3-0504-04'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0848-04'

           end


-- added 11/14/2006 by WKurth per Carl K request
if @sname='ACSMASTART' and @mname='81104-1343-001140H'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0726-08'
           end

-- added 10/18/2006 per Carl K request
if @sname='ACSMASTART' and @mname='821110513-001040AR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end


-- added 10/25/2006 per Doug S request
if @sname='ACSP2DPACKAGE' and @mname='203-752-002'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0734-10'
           end



-- added 12/15/2006 per Carl C request
if @sname='ACSP2DPACKAGE' and @mname='203-821-001'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0734-10'
           end

-- added 12/6/2007 per Carl C request
if @sname='ACSPWPACKAGE' and @mname='668915-001001-2210'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end


-- added 12/6/2007 per Carl C request
if @sname='ACSPWPACKAGE' and @mname='668915-001001-2210'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2760'
           end

--added 10/18/2006 per Doug Sustaire request
if @sname='ACSMASTART' and @mname='82112-0112-003020'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-04'
           end


-- potentiall add on 11/28/2006 by wk per reid fischer
/*if @sname='ACSHEENGINE' and @mname='PS7-3000'
           begin
		update BOM_Level_Station set part_number='3-0937-04'
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0918-04'
           end
*/
if @sname='ACS4410BACK' and @mname='F42-14201'
	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02'
	end

-- potential add on 12/18/2006 by WK per rick weston request
if @sname='ACS4410BACK' 
begin
    if ( substring(@mname,1,2) = 'F4' ) and (substring(@mname,5,2) = '16') and len(@mname) = 9
    begin
        select 'hello'
    end
    else
    begin
	delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0775-01'

    end
end

--added 12/07/2006  by WK perBrian  request
if @sname='ACSMASTART' and @mname='81104-0943-001140H'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0726-08'
           end

-- added 02/09/2007 by WK per Jo Holthe request
if @sname='FUL2PACKAGE' and @mname='MG10-OEM-05VR'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2547'
           end


if @sname='ACSEEFUL2' and substring(@mname,1,4) = '203-'
begin
   insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in 203 part and ACS Serial number',getdate(), 0, 1,1 ) 
end
if @sname='ACSEEFULRCStart' and substring(@mname,1,4) = '203-'
begin
   insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCStart', @mname, @mname, 'A','Scan in 203 part and ACS Serial number',getdate(), 0, 1,1 ) 
end
-- added 11/12/2007 by WK per Brian request
if @sname ='ACSEEFUL2' and @mname='QS65B-3140102-401R'
begin
   delete from BOM_Level_Station
      where Station=@sname and SAP_Model=@mname and Part_Number='5-2997-03'  
end

-- added 2/9/2007 by WK per request from Jo Holthe
if @sname ='ACSEEFUL2' and @mname='MG10-OEM-05VR'
begin
   delete from BOM_Level_Station
      where Station=@sname and SAP_Model=@mname and Part_Number='6-1218'  
end

if ( substring(@sname,1,11)='QS65FulFill' and @mname = 'QS65B-5110001'  )
begin
   if exists (select station from BOM_Level_Station where Station = @sname and @mname = 'QS65B-5110001'  and part_number = '5-2510-02' )
   begin
        delete BOM_Level_Station
               where station = @sname and @mname= 'QS65B-5110001'  and part_number = '5-2510-01'
   end
end

-- added 4/16/2008 per Jo Holthe request
if @sname ='ACSEEFUL2' and substring(@mname,1,4)='MG10'
begin
   delete from BOM_Level_Station
      where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'  
end

if @sname ='ACSEEFULRCSTART' and substring(@mname,1,4)='MG10'
begin
   delete from BOM_Level_Station
      where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'  
end

-- added 05/3/2007 by WK per request from Jo Holthe
if @sname ='ACSEEFUL2' and @mname='07200101-0100-0008'
begin
   delete from BOM_Level_Station
      where Station=@sname and SAP_Model=@mname and Part_Number='5-1050-08'  
end

if @sname='ACSEEFUL2' and substring(@mname,1,4) = 'SR60'
begin
   insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in SR60 part and ACS Serial number',getdate(), 0, 1,1 ) 
end
if @sname='ACSEEFULRCStart' and substring(@mname,1,4) = 'SR60'
begin
   insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCStart', @mname, @mname, 'A','Scan in SR60 part and ACS Serial number',getdate(), 0, 1,1 ) 
end

if @sname='ACSP2DPACKAGE' and @mname = '203-751-001'
   begin
        delete BOM_Level_station
          where Station=@sname and SAP_Model=@mname and Part_Number='8-0424-03'
   end


if @sname='ACSP2DPACKAGE' and @mname = '203-752-001'
   begin
        delete BOM_Level_station
          where Station=@sname and SAP_Model=@mname and Part_Number='8-0481-10'
   end
/*
if @sname='ACS4410BACK' and @mname in (
'F42-15204',

'F42-15224',
'F42-15234',
'F42-15221',
'F42-15231',
'F42-15223'
)

	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02 '
	end

*/

/*

if @sname = 'ACSEEFULRCSTART' and (substring(@mname,1,3) = 'M22' OR substring(@mname,1,3) = 'M23')
begin
  insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCSTART', @mname, @mname, 'A','Scan in M22 part and ACS Serial number',getdate(), 0, 1,1 ) 

end


if @sname = 'ACSEEFUL2' and (substring(@mname,1,3) = 'M22' OR substring(@mname,1,3) = 'M23')
begin
  insert into BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in M22 part and ACS Serial number',getdate(), 0, 1,1 ) 

end
*/
/* removed per Doug's request on 1/20/2007 WK
if @sname='ACS4410BACK' and substring(@mname,1,6) = 'F42-15'

	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02'
	end*/
-- wk 11/28/2006 added per rick weston, dave shoop request
if @sname='ACS4410BACK' and @mname like 'F4_-13___'

	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0714-02'
	end


if @sname='acsp2dpackage' and @mname = '321-635-001'

	begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0424-03'
	end

-- wdk 09/20/06 per Rick Weston
if @sname ='ACSDOSCASEFRONT' and  substring(@mname,1,3) in ( '75-','32X','31X')
begin
    delete BOM_Level_Station
           where Station=@sname and SAP_model = @mname and Part_Number in ('6301-0018','6301-0019')
end


-- wdk 05/25/07 per Rick Weston
if @sname ='ACSDOSCASEFRONT' and  ( substring(@mname,1,3) in ( '75-') or substring(@mname,1,2) in ( '32','31'))
begin
    delete BOM_Level_Station
           where Station=@sname and SAP_model = @mname and Part_Number in ('6301-0018','6301-0019')
end


-- added 1/20/2007 by WK per Rick Weston's request
if @sname ='ACSDOSCASEFRONT' and  substring(@mname,1,2) =  '32' and len(rtrim(@mname)) = 12
begin
    delete BOM_Level_Station
           where Station=@sname and SAP_model = @mname and Part_Number in ('6301-0018')
end

-- wdk 02/07/06 for Jo Holthe
if  exists ( select BOMLevel from BOM_Level_Station where station = @sname and SAP_Model= @mname and 
Part_Number in ('5-2269-07','5-2269-08','5-2269-09','5-2269-10','5-2269-11','5-2269-12','5-2269-13','5-2269-14','5-2269-15'))
begin
   delete BOM_Level_Station
       where station = @sname and SAP_Model=@mname and Part_Number = '5-2164'
end


-- WDK 02222006
/*
if  @sname = 'ACSMAMOUNT' and substring(@mname,1,3) in ('812','822','108','205')
	begin
		update BOM_Level_Station set Qnty = 2
			where Station=@sname and SAP_Model=@mname and Part_Number = '6-1011' and Qnty = 3
	end

if  @sname = 'ACSMAMOUNT' and substring(@mname,1,3) in ('811','821','109','206')
	begin
		update BOM_Level_Station set Qnty = 1
			where Station=@sname and SAP_Model=@mname and Part_Number = '6-1011' and Qnty = 2
	end
*/

if  exists ( select BOMLevel from BOM_Level_Station where station = @sname and SAP_Model= @mname and 
SAP_Model in ('5-2269-07','5-2269-08','5-2269-09','5-2269-10','5-2269-11','5-2269-12','5-2269-13','5-2269-14','5-2269-15'))
begin
   delete BOM_Level_Station
       where station = @sname and SAP_Model=@mname and Part_Number = '5-2164'
end

/*   DELETE BOM OVERRIDES AFTER moving assembly to VIPEROPTICSLOAD
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
*/

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and @sname='ACS4410BACK' and SAP_Model=@mname and SAP_Model in ('F42-14236',

'F42-14234',

'F42-14231'

))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0622-02 ','3-0622-01')
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname  and SAP_Model=@mname and SAP_Model = 'F42-14221')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0622-02' )
  end

if exists(select BOMLevel from BOM_Level_Station where Station=@sname and @sname = 'ACS4410BACK' and SAP_Model=@mname and Part_Number='3-0530-08')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

--!#@$!#$@#$
-- WDK to take care of two parts for VIPER
/*
if (@sname = 'ViperStart') and (( @mname like '5-2350-%') or ( @mname like '5-2299-%')) 
begin
if   exists(select * from bom_level_station where station='ViperStart' and part_number='5-1885' )
begin
   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname
end
end
*/

if ( @sname='ViperStart' and @mname like '85%' )
begin
   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname


   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-2764' and sap_model=@mname
end

----kvan BOMOVERRIDE
--if exists(select * from BOM_Level_Station  WHERE part_number = '700261000'  and Station ='ACSVNZZMAINBD')
--  begin
	
--UPDATE BOM_Level_Station 
--SET part_number = '700008600' WHERE part_number = '700261000'  and Station ='ACSVNZZMAINBD'
--  end
----kvan BOMOVERRIDE

--kvan BOMOVERRIDE
if exists(select *
	from BOM_Level_Station
	WHERE part_number = '700005210' and Station ='ACSVNCOLBASEONE' AND bom_date_time < '05/23/2016 06:00')
begin

	UPDATE BOM_Level_Station
	SET part_number = '700005201'
	WHERE part_number = '700005210' and Station ='ACSVNCOLBASEONE' AND bom_date_time < '05/23/2016 06:00'
end

--kvan BOMOVERRIDE

----kvan close 19May
--if exists(select * from BOM_Level_Station  WHERE part_number = '700261000'  and Station ='ACSVNZZMAINBD')
--  begin
	
--UPDATE BOM_Level_Station 
--SET part_number = '700008600' WHERE part_number = '700261000'  and Station ='ACSVNZZMAINBD'
--  end
----kvan close 19May


--kvan close 8 May
if exists(select * from BOM_Level_Station  WHERE part_number = '700241600 '  and Station ='ACSVNTIGBASEST' AND sap_model ='740201200')
  begin
	
UPDATE BOM_Level_Station 
SET part_number = '52-0054-00' WHERE part_number = '700241600 '  and Station ='ACSVNTIGBASEST' AND sap_model ='740201200'
  end
--kvan close 08 May

--kvan add station= ACSVN198LOWER, sap_model ='740224900', part_number ='683943011'
IF NOT EXISTS (
SELECT * FROM bom_level_station WHERE station= 'ACSVN198LOWER' and sap_model ='740224900' and part_number ='683943011'
)
BEGIN
insert into bom_level_station 
(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


(select top 1 'ACSVN198LOWER', '740224900', '683943011', Rev, '683943011-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
from BOM_Level_Station WHERE station= 'ACSVN198LOWER' and sap_model ='740224900' and Part_Number ='info')
end

--kvan close 2 June
--if exists(select * from BOM_Level_Station  WHERE part_number = '663659010' AND ( sap_model = '740154400' OR sap_model = '740154500' ) and Station ='ACSVN198LOWER')
--  begin
	
--UPDATE BOM_Level_Station 
--SET part_number = '662909025' WHERE part_number = '663659010' AND ( sap_model = '740154400' OR sap_model = '740154500' )
--  end
--kvan close 2 June

--kvan open 2 June- trieu
--if exists(select * from BOM_Level_Station  WHERE part_number = '663438016' and Station ='ACSVNCOLENGONE')
--  begin
	
--UPDATE BOM_Level_Station 
--SET part_number = '663438014' WHERE part_number = '663438016'and Station ='ACSVNCOLENGONE'
--  end
--kvan close plan 2 July


----kvan open 25 Jun- wait bill fix
--if exists(select * from BOM_Level_Station  WHERE (sap_model = '740154400' ) and Station ='ACSVN198BASEST' and  Part_Number ='info')
--  begin
--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


--(select top 1 'ACSVN198BASEST', '740154400', '700230600', Rev, '700230600-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
--from BOM_Level_Station where SAP_Model ='740154400' and Part_Number ='info')

--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)

--(select top 1 'ACSVN198BASEST', '740154400', '278128601', Rev, '278128601-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, '', ProdOrder
--from BOM_Level_Station where SAP_Model ='740154400' and Part_Number ='info')

--  end


--  if exists(select * from BOM_Level_Station  WHERE (sap_model = '740154500' ) and Station ='ACSVN198BASEST' and  Part_Number ='info')
--  begin
--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


--(select top 1 'ACSVN198BASEST', '740154500', '700230600', Rev, '700230600-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
--from BOM_Level_Station where SAP_Model ='740154500' and Part_Number ='info')

--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)

--(select top 1 'ACSVN198BASEST', '740154500', '278128601', Rev, '278128601-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, '', ProdOrder
--from BOM_Level_Station where SAP_Model ='740154500' and Part_Number ='info')

--  end


--    if exists(select * from BOM_Level_Station  WHERE (sap_model = '740153900' ) and Station ='ACSVN198BASEST' and  Part_Number ='info')
--  begin
--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


--(select top 1 'ACSVN198BASEST', '740153900', '700230600', Rev, '700230600-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
--from BOM_Level_Station where SAP_Model ='740153900' and Part_Number ='info')

--insert into bom_level_station 
--(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)

--(select top 1 'ACSVN198BASEST', '740153900', '278128601', Rev, '278128601-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, '', ProdOrder
--from BOM_Level_Station where SAP_Model ='740153900' and Part_Number ='info')

--  end

  ----

    ---kvan add cho Toàn - statin ACSVNMAREMOTE- autolose
    if exists(select * from BOM_Level_Station  WHERE Station ='ACSVNMAREMOTE' and  Part_Number ='INFO' and (SAP_Model <>''  or SAP_Model = @mname) )
	begin
	--delete
	delete BOM_Level_Station  WHERE Station ='ACSVNMAREMOTE' and  Part_Number ='BASELABEL'

	-- insert base label
	
insert into BOM_Level_Station 
select 
Station, SAP_Model, 'BASELABEL', Rev, Description, BOM_Date_Time, ACSEEMode, 1, BOMLevel, 'P', ProdOrder
 from BOM_Level_Station  WHERE Station ='ACSVNMAREMOTE' and  Part_Number ='INFO' and SAP_Model <>''
	end
----kvan add cho Toàn - statin ACSVNMAREMOTE

--  ---kvan add cho Hoang 23 feb 2016
--    if exists(select * from BOM_Level_Station  WHERE (sap_model = '700090900' ) and Station ='ACSVNZZMAINBD' and  Part_Number ='700261000')
--  begin
--UPDATE bom_level_station SET Part_Number ='700008600'
--WHERE (sap_model = '700090900' ) and Station ='ACSVNZZMAINBD' and  Part_Number ='700261000'
--end
-----kvan add cho Hoang 23 feb 2016- plan close mar 2016
  ----kvan open 25 Jun- wait bill fix-close


  -- kvan control mp focus
  --removed on 29/Dec
  /*
IF EXISTS (select * 
FROM dbo.BOM_Level_Station 
WHERE SAP_Model='700101702' AND Part_Number LIKE '6[68]%' AND station ='ACSVNMPMODST')
BEGIN
	delete
FROM dbo.BOM_Level_Station 
WHERE SAP_Model='700101702' AND Part_Number LIKE '6[68]%' AND station ='ACSVNMPMODST'

delete
FROM ACSEEClientState.dbo.Parts_Level 
WHERE SAP_Model='700101702' AND Part_Number LIKE '6%'AND station ='ACSVNMPMODST'
END
*/
  if exists(select * from BOM_Level_Station  WHERE (sap_model = '740154200' ) and Station ='ACSVN198BASEST' and  Part_Number ='info')
  begin
insert into bom_level_station 
(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


(select top 1 'ACSVN198BASEST', '740154200', '700230600', Rev, '700230600-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
from BOM_Level_Station where SAP_Model ='740154200' and Part_Number ='info')

insert into bom_level_station 
(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)

(select top 1 'ACSVN198BASEST', '740154200', '278128601', Rev, '278128601-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, '', ProdOrder
from BOM_Level_Station where SAP_Model ='740154200' and Part_Number ='info')

  end

  if exists(select * from BOM_Level_Station  WHERE (sap_model = '740154600' ) and Station ='ACSVN198BASEST' and  Part_Number ='info')
  begin
insert into bom_level_station 
(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)


(select top 1 'ACSVN198BASEST', '740154600', '700230600', Rev, '700230600-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder
from BOM_Level_Station where SAP_Model ='740154600' and Part_Number ='info')

insert into bom_level_station 
(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)

(select top 1 'ACSVN198BASEST', '740154600', '278128601', Rev, '278128601-Des', (select GETDATE()), ACSEEMode, Qnty, BOMLevel, '', ProdOrder
from BOM_Level_Station where SAP_Model ='740154600' and Part_Number ='info')

  end
--kvan open 25 Jun- wait bill fix


--------------------------------------
-- FIX TEMP Acsvnhuystart
--if exists(select * from BOM_Level_Station WHERE sap_model ='740022600' and Part_Number='INFO' and station ='ACSVNHUYMAINA')
--  begin

---- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
----select 'ACSVNHUYSTART', '740022600', '5-3188', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
------where sap_model ='740022600' and Part_Number='INFO' and station ='ACSVNHUYMAINA'

--END
--------------------------------------


-- KVAN ADD FOR DOZER
--if ( @sname='ACSVNTWOSTART' and @mname = 'DSE0420' )
--begin
----c525
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '683459002', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740099100' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '740045100', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740099100' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, 'DSE0420-C525', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740099100' and sap_model=@mname

-----
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '683459002', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740147000' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '740045100', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740147000' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, 'DSE0420', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740147000' and sap_model=@mname

-----DSE0420-D
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '683459002', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740165700' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '740045100', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740165700' and sap_model=@mname

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, 'DSE0420-D', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740165700' and sap_model=@mname
------

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '683459090', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740076200' and sap_model=@mname 

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '740045100', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740076200' and sap_model=@mname


 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, 'DSE0420-HP', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740076200' and sap_model=@mname

------740152400 - C599

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '683459011', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740152400' and sap_model=@mname 

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, '740045100', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740152400' and sap_model=@mname


 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, 'DSE0420-HP-C599', Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNTWOSTART' and part_number='740152400' and sap_model=@mname
------740152400 - C599


DECLARE  @consmodel nchar(30) ='DSE0420-HP-C695' ;
--DECLARE  @mname nchar(30) ='DSE0420-HP-C695' ;
DECLARE  @consstation nchar(30) ='ACSVNTWOSTART';
DECLARE  @consbasepart nchar(30) ='740178100';
DECLARE  @addpart1 nchar(30) ='740045100';
DECLARE  @addpart2 nchar(30) ='683846022';
--DECLARE  @addpart3 nchar(30) ='';

IF  EXISTS (SELECT * FROM dbo.BOM_Level_Station bls WHERE bls.SAP_Model =@consmodel AND bls.Station=@consstation)
BEGIN
	
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart1, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname 

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart2, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname


 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @consmodel, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname

END

--#region DSE0420-DPT-C695
DECLARE  @consmodel1 nchar(30) ='DSE0420-DPT-C695' ;
DECLARE  @consstation1 nchar(30) ='ACSVNTWOSTART';
DECLARE  @consbasepart1 nchar(30) ='740211300';
DECLARE  @addpart11 nchar(30) ='740045100';
DECLARE  @addpart21 nchar(30) ='684063011';
--DECLARE  @addpart3 nchar(30) ='';


IF  EXISTS (SELECT * FROM dbo.BOM_Level_Station bls WHERE bls.SAP_Model =@consmodel1 AND bls.Station=@consstation1)
BEGIN
	if not exists (select part_number from BOM_Level_Station where part_number=@addpart11 and Station=@consstation1 and SAP_Model=@consmodel1)
	begin 
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart11, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation1 and part_number=@consbasepart1 and sap_model=@mname 
end
if not exists (select part_number from BOM_Level_Station where part_number=@addpart21 and station=@consstation1 and SAP_Model=@consmodel1)
	begin 
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart21, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation1 and part_number=@consbasepart1 and sap_model=@mname
end
END
--#endregion DSE0420-DPT-C695

--#region DSE0420-C726
SET  @consmodel  ='DSE0420-C726' ;
SET  @consstation  ='ACSVNTWOSTART';
--DECLARE  @consbasepart nchar(30) ='740178100';
SET  @addpart1  ='740045100';
SET  @addpart2  ='683846010';
--DECLARE  @addpart3 nchar(30) ='';


IF  EXISTS (SELECT * FROM dbo.BOM_Level_Station bls WHERE bls.SAP_Model =@consmodel AND bls.Station=@consstation)
BEGIN
	
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart1, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname 

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart2, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname


 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @consmodel, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname

END
--#endregion DSE0420-C726

--#region DSE0450
SET  @consmodel  ='DSE0450' ;
SET @consbasepart = '740230000';
SET  @consstation  ='ACSVNTWOSTART';
SET  @addpart1  ='740045100';
SET  @addpart2  ='684063031';
--DECLARE  @addpart3 nchar(30) ='';


IF  EXISTS (SELECT * FROM dbo.BOM_Level_Station bls WHERE bls.SAP_Model =@consmodel AND bls.Station=@consstation)
BEGIN
	
 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart1, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname 

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, SAP_Model, @addpart2, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station=@consstation and part_number=@consbasepart and sap_model=@mname

END
--#endregion DSE0450

--end
-- KVAN ADD FOR mgl3233 24 sEP THI REQUEST
-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, SAP_Model, '700034400', Rev, 'ASSY,IMAGER,MGL3200VSi', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' and part_number='700094300' and sap_model=@mname
-- KVAN ADD FOR mgl3233-end

-- KVAN ADD FOR DOZER

-- kvan add to fix pulling bom
UPDATE bom_level_station 
SET part_number = '90A052138' 
WHERE part_number = '90a052138'
-- kvan add to fix pulling bom

/*  feb 08 add control part It's ME kvan*/

DECLARE	@return_table TABLE (Result varchar(200))
DECLARE @KQ varchar(200)

-- INSERT into @return_table  EXEC  amevn_checkNaddXME '5-2809', 'ACSVNHUYREMOTE' -- for test
INSERT into @return_table  EXEC  amevn_checkNaddXME @mname, @sname

(SELECT	TOP 1 @KQ =Result FROM @return_table)


IF @KQ ='OK'

   --- DO INSERT
   if not exists (select Part_Number from BOM_Level_Station bls WHERE bls.Station=@sname AND SAP_Model= @mname AND part_number =@mname)
	begin
		INSERT INTO bom_level_Station
		(Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, Part_Type, ProdOrder)
		select
		Station, @mname SAP_Model, @mname Part_Number, Rev, Description, getdate(), ACSEEMode, 1, 1, Part_Type, ProdOrder
		 from BOM_Level_Station
		where Station=@sname and SAP_Model=@mname AND part_number ='INFO'
	END

/*  feb 08 add control part It's ME*/
 


-- kvan add ECO 14899 Upgrade 700081400 Rev. X6.
--In the BOM of the 700081400 replace 700019200 with 700229100
--**Part Number 700019200 is used for other products therefore it does not need to be obsoleted.

--if exists (select Part_Number from BOM_Level_Station where station='ACSVNCOLENGONE' and sap_model='700081400' and part_number='700229100')
--begin
--	update BOM_Level_Station set Part_Number='700019200' where station='ACSVNCOLENGONE' and sap_model='700081400' and part_number='700229100'
--end
-- kvan add ECO 14899 Upgrade 700081400 Rev. X6.

--KVAN ADD FOR COBATO


-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740092300', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740092300' and Part_Number ='INFO'
-- remove 12 May 2015


-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740092600', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740092600' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740093600', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740093600' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740092800', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740092800' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740092300', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740092300' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740092900', '700189900', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNCOBABASEST' AND sap_model='740092900' and Part_Number ='INFO'

--KVAN ADD FOR COBATO


----start-Kvan add ACSVNTigBASEST
-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740032600', '700034400', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' AND sap_model='740032600' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740032700', '700034400', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' AND sap_model='740032700' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740159200', '700233500', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' AND sap_model='740159200' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740159000', '700233500', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' AND sap_model='740159000' and Part_Number ='INFO'

-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '740158900', '700233500', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNTIGBASEST' AND sap_model='740158900' and Part_Number ='INFO'
----end-Kvan add ACSVNTigBASEST


--start-Kvan add ACSVNORIOMODST
-- insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
--select Station, '700', '700233500', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
--where station='ACSVNORIOMODST' AND sap_model='740158900' and Part_Number ='INFO'
--end-Kvan add ACSVNORIOMODST

--KVAN ADD FOR 70010170*

IF EXISTS (
SELECT * FROM dbo.BOM_Level_Station AS BOM WHERE sap_model like '70010170%'
)
BEGIN
	--SELECT * 
	delete FROM dbo.BOM_Level_Station  WHERE sap_model like '70010170%' AND BOMLevel > 1
END
--KVAN ADD FOR 70010170*-end

--KVAN ADD FOR ACSVNLIONMODST

 insert BOM_Level_Station (Station, SAP_Model,Part_Number , Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder) 
select Station, '700233500', '662783012', Rev, 'ASSY,IMAGER', BOM_Date_Time, ACSEEMode, Qnty, BOMLevel, ProdOrder from bom_level_station 
where station='ACSVNLIONMODST' AND sap_model='700233500' and Part_Number ='INFO'

--KVAN ADD FOR ACSVNLIONMODST

if ( @sname='ViperStart' and @mname like '86%' )
begin


   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-2764' and sap_model=@mname
end



if ( @sname='ViperStart' and @mname like 'mg%' )
begin
   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname



   insert BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from bom_level_station 
where station='ViperStart' and part_number='5-2764' and sap_model=@mname
end


if ( @sname = 'ACS4410BACK' and @mname like 'F42-___4_' )
begin
   delete from BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '3-0622-02')
end

--if   exists(select BOMLevel from BOM_Level_Station where @sname='ViperStart'  and SAP_Model=@mname and sap_model like '5-2350-%' and station='ViperStart')
--begin
--   insert BOM_Level_Station select * from bom_level_station where station='ViperStart'
--end



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

if exists(select BOMLevel from BOM_Level_Station with(NOLOCK) where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-24')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-06','3-0542-04','3-0542-02')
  end

if exists(select BOMLevel from BOM_Level_Station with(NOLOCK) where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-06')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-04','3-0542-02')
  end
--- wkurth added 7/22


if exists(select BOMLevel from BOM_Level_Station with(NOLOCK) where Station=@sname and SAP_Model=@mname and Part_Number='664415-001005-0000')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1530')
  end

-- end of wkurth added 7/22

-- DOS Falcon
if @sname='ACSDOSCASEFRONT'
  begin
	if substring(@mname,1,2) in ('32','31','70','71','72','73','74','75')
	  begin
		delete BOM_Level_Station
	   	  where Station=@sname and SAP_Model=@mname and Part_Number in ('0801-1041-05', '0801-1042-00', '6301-0001')
	  end
  end


-- End DOS Falcon

-- FFC BOM override
if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1100', 'QS6-2100', 'QS6-4100', 'QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100','QS6-A110'))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1530')
  end

-- WDK 090605
if exists ( select BOMLevel from BOM_Level_Station where Station = @sname and SAP_Model=@mname and Part_Number in ( '7-0204'))
  begin
     delete BOM_Level_Station
        where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1561')
  end
-- WDK


if exists(select BOMLevel from BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100', 'QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','667015-020000-0000','668415-019000-0000','668712-014006-0000',
'669019-001001-0000'))
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

if @mname in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100','QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','667015-020000-0000','668415-019000-0000','668712-014006-0000',
'669019-001001-0000')
  begin
	delete BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

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
                 if len(rtrim(@ProdOrder)) > 0 
                 begin
	   select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
		BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
		Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
		Partlist.Automatic As Display_Option, 
		Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel,
                           isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
		from Partlist with(NOLOCK) Inner join Catalog with(NOLOCK)
		on Partlist.Part_No = Catalog.Part_No_Count
		Inner join Stations with(NOLOCK) on Partlist.Station = Stations.Station_Count
		Inner join BOM_Level_Station with(NOLOCK) on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
		Left Outer Join MappedFileNames with(NOLOCK) on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
		where Stations.Station_Name=@sname and BOM_Level_Station.Station=@sname and 
			BOM_Level_Station.SAP_Model = @mname and ProdOrder = @ProdOrder
		Order by Catalog.Part_No_Name

		return

                 end
                 else
                 begin

	   select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
		BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
		Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
		Partlist.Automatic As Display_Option, 
		Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel,
                           isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
		from Partlist with(NOLOCK) Inner join Catalog with(NOLOCK)
		on Partlist.Part_No = Catalog.Part_No_Count
		Inner join Stations with(NOLOCK) on Partlist.Station = Stations.Station_Count
		Inner join BOM_Level_Station with(NOLOCK) on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
		Left Outer Join MappedFileNames with(NOLOCK) on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number  
		where Stations.Station_Name=@sname and BOM_Level_Station.Station=@sname and 
			BOM_Level_Station.SAP_Model = @mname 
		Order by Catalog.Part_No_Name

		return
              end
	  end

	else -- we have a test station
	 begin

-- added by W Kurth on 2/16/2011 per ECD 66739 and discussion with Randy and Al

if @sname like 'MUSEOCON%'
begin

 if exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='610001000'  and substring(BOM_Level_Station.Part_Type,1,1)='A'  )
begin

  if not exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='610001000'  and substring(BOM_Level_Station.Part_Type,1,2)='AL' and BomLevel = 1 )
  begin

      insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel ,part_type )
      select  Station, SAP_Model,'610001000' , Rev,Description, BOM_Date_Time, ACSEEMode, Qnty, 1, 'AL'
      from BOM_Level_Station where station = @sname and SAP_Model=@mname and Part_Number = '610001000' 
  end 
end
end

if ((@sname like 'BSCAN%') and (@mname like '662904011%'))
begin

if not exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='610001715')
begin
      insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel ,part_type )
      values (@sname,@mname,'610001715','A','APP CODE,V5.3.103, GBT44XX',getdate(),0, 1, 1, 'A')
end 
if not exists ( select Part_Number from BOM_Level_Station where  Station=@sname and SAP_Model=@mname and Part_Number='610001112')
begin
      insert into BOM_Level_Station ( Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel ,part_type )
      values (@sname,@mname,'610001112','A','BOOT LOADER, HH, 5.3.103',getdate(),0, 1, 1, 'B')
end 
end
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
                 if len(rtrim(@ProdOrder)) > 0 
                 begin
	   	select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
			Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
			Partlist.Automatic As Display_Option, 
			Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel ,
                                        isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
			from Partlist with(NOLOCK) Inner join Catalog with(NOLOCK)
			on Partlist.Part_No = Catalog.Part_No_Count
			Inner join Stations with(NOLOCK) on Partlist.Station = Stations.Station_Count
			Inner join BOM_Level_Station with(NOLOCK) on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
			Left Outer Join MappedFileNames with(NOLOCK) on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
			where Stations.Station_Name=@sname AND bom_level_station.Station=@sname and
				BOM_Level_Station.SAP_Model = @mname  and ProdOrder = @ProdOrder
		union
		select BOM_Level_Station.SAP_Model,BOM_Level_Station.Part_Number,BOM_Level_Station.Rev,BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, 'Station' as Station,
			'X' as Part_Type, BOM_Level_Station.ACSEEMode, 
			'A' as Display_Option, '1' as Display_Order,MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel ,
                                       isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
			 from BOM_Level_Station with(NOLOCK)
			Left Outer Join MappedFileNames on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number 
			where BOM_Level_Station.Station=@sname and BOM_Level_Station.SAP_Model = @mname  and ProdOrder = @ProdOrder and ( ( substring(BOM_Level_Station.Part_Number,1,3) = 'R96' 
			or substring(BOM_Level_Station.Part_Number,1,4) = 'INFO' 
			or substring(BOM_Level_Station.Part_Number,1,3) = 'ERS'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'R56'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XBL'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'X96'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XLA'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XLB'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XHA'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XHB'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'eb'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'nk'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XVA' 
                                        or substring(BOM_Level_Station.Part_Number,1,2) = '62'
                                        or substring(BOM_Level_Station.Part_Number,1,3) = 'WCA' 
                                        or substring(BOM_Level_Station.Part_Number,1,3) = 'MBL'
                                        or substring(BOM_Level_Station.Part_Number,1,3) ='610'
                                        or substring(BOM_Level_Station.Part_Number,1,2) = 'DR'
                                         ) or
                                         (
           --                                substring(BOM_Level_Station.Part_Type,1,1)='A' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='AR' 
           --                               or substring(BOM_Level_Station.Part_Type,1,1)='B' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='BA' 
           --                               or substring(BOM_Level_Station.Part_Type,1,1)='C' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='CA'
           --                               or substring(BOM_Level_Station.Part_Type,1,1)='D' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,1)='E' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,1)='F' 
           --                                or  substring(BOM_Level_Station.Part_Type,1,2)='AL' 
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='BL' 
										 -- or  substring(BOM_Level_Station.Part_Type,1,2)='K'
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='VE'
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='WE'
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='WG'
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='WI'
           --                               or  substring(BOM_Level_Station.Part_Type,1,2)='WP' 	
										 -- or  substring(BOM_Level_Station.Part_Type,1,2)='WM'	
										 --or  substring(BOM_Level_Station.Part_Type,1,3)='WLB'
										 -- or  substring(BOM_Level_Station.Part_Type,1,3)='WMB'	
						  	  --            or  substring(BOM_Level_Station.Part_Type,1,3)='WHB'
										 --  or  substring(BOM_Level_Station.Part_Type,1,3)='TDR'

											rtrim(ltrim(BOM_Level_Station.Part_Type)) IN (select ACS_SAP_PartType.PartType from ACS_SAP_PartType where flgTest=1)
                                        )
                                         )
                end
                else
                    begin
	   	select BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, BOM_Level_Station.Rev, BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
			Partlist.Get_Serial As Part_Type, BOM_Level_Station.ACSEEMode, 
			Partlist.Automatic As Display_Option, 
			Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel ,
                                        isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
			from Partlist with(NOLOCK) Inner join Catalog with(NOLOCK)
			on Partlist.Part_No = Catalog.Part_No_Count
			Inner join Stations with(NOLOCK) on Partlist.Station = Stations.Station_Count
			Inner join BOM_Level_Station with(NOLOCK) on BOM_Level_Station.Part_Number = Catalog.Part_No_Name
			Left Outer Join MappedFileNames with(NOLOCK) on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
			where Stations.Station_Name=@sname AND bom_level_station.Station=@sname and
				BOM_Level_Station.SAP_Model = @mname 
		union
		select BOM_Level_Station.SAP_Model,BOM_Level_Station.Part_Number,BOM_Level_Station.Rev,BOM_Level_Station.Description,
			BOM_Level_Station.BOM_Date_Time, 'Station' as Station,
			'X' as Part_Type, BOM_Level_Station.ACSEEMode, 
			'A' as Display_Option, '1' as Display_Order,MappedFileNames.MappedFileName,BOM_Level_Station.Qnty,BOM_Level_Station.BOMLevel ,
                                       isnull(BOM_Level_Station.Part_Type,'') as ACS_Part_Type 
			 from BOM_Level_Station with(NOLOCK)
			Left Outer Join MappedFileNames with(NOLOCK) on BOM_Level_Station.Part_Number = MappedFileNames.Part_Number 
			where BOM_Level_Station.Station=@sname and BOM_Level_Station.SAP_Model = @mname and ( ( substring(BOM_Level_Station.Part_Number,1,3) = 'R96' 
			or substring(BOM_Level_Station.Part_Number,1,4) = 'INFO' 
			or substring(BOM_Level_Station.Part_Number,1,3) = 'ERS'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'R56'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XBL'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'X96'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XLA'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XLB'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XHA'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XHB'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'eb'
			or substring(BOM_Level_Station.Part_Number,1,2) = 'nk'
			or substring(BOM_Level_Station.Part_Number,1,3) = 'XVA' 
                                        or substring(BOM_Level_Station.Part_Number,1,2) = '62'
                                        or substring(BOM_Level_Station.Part_Number,1,3) = 'WCA' 
                                        or substring(BOM_Level_Station.Part_Number,1,3) = 'MBL'
                                        or substring(BOM_Level_Station.Part_Number,1,3) ='610'
                                        or substring(BOM_Level_Station.Part_Number,1,2) = 'DR'
                                         ) or
                                         (
            --                               substring(BOM_Level_Station.Part_Type,1,1)='A' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='AR' 
            --                              or substring(BOM_Level_Station.Part_Type,1,1)='B' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='BA' 
            --                              or substring(BOM_Level_Station.Part_Type,1,1)='C' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='CA'
            --                              or substring(BOM_Level_Station.Part_Type,1,1)='D' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,1)='E' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,1)='F' 
            --                               or  substring(BOM_Level_Station.Part_Type,1,2)='AL' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='BL' 
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='K'
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='VE'
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='WE'
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='WG'
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='WI'
            --                              or  substring(BOM_Level_Station.Part_Type,1,2)='WP' 	
										  --or  substring(BOM_Level_Station.Part_Type,1,2)='WM'		

 										 -- or  substring(BOM_Level_Station.Part_Type,1,3)='WLB'
										  --or  substring(BOM_Level_Station.Part_Type,1,3)='WMB'	
						  	   --           or  substring(BOM_Level_Station.Part_Type,1,3)='WHB'
										  --or  substring(BOM_Level_Station.Part_Type,1,3)='TDR' --Kadd10Sep
										  rtrim(ltrim(BOM_Level_Station.Part_Type)) IN (select ACS_SAP_PartType.PartType from ACS_SAP_PartType where flgTest=1)
                                        )
                                         )

                     end
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



/*Clean up part with qty <=0 kvan */

delete from dbo.BOM_Level_Station  WHERE Qnty <=0
--AND  Part_Number NOT in( 'INFO', 'BOMCOUNT')
AND (part_number <>'INFO' OR part_number <>'BOMCOUNT')




GO