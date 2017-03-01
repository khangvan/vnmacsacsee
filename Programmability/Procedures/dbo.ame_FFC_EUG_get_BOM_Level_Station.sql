SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_FFC_EUG_get_BOM_Level_Station]
-- Define input parameters
	@sname 		char(20) = NULL,
	@mname		char(20) = NULL,
	@testStn	int = 0 -- 0 is false(use part control) and 1 is true -- Define code
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
	[BOMLevel] [int] NULL 
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
/*** taken out for VIPEROPTICS parts from VPOMEGAFINISH
if @sname='ViperOpticsLoad' and substring(@mname,1,3) in ('851','852','951','952','953')
	begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and substring(Part_Number,1,2)<>'5-'
	end
*/
-- wdk 01/30/2006  - for R. Weston
if ( @sname = 'ACSDOCKSTART' and  @mname = '7-0858' )
begin
   delete from FFC_EUG_BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '4-3926-01')
end

-- RFID BOM override
if @sname='ACS4410CASEBACK' and substring(@mname,1,3)='F50'
	begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-3626-02'
	end



if @sname='ACSMASTART' and @mname='81104-1343-001140H'
           begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-08'
           end


if @sname='ACSMASTART' and @mname='821100244-001040AR'
           begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0716-04'
           end

if @sname='ACSMASTART' and @mname='81104-0943-001140H'
           begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-08'
           end


if @sname='ACS4410BACK' and @mname='F42-14201'
	begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02'
	end

if @sname='ACSEEFUL2' and substring(@mname,1,4) = '203-'
begin
   insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in 203 part and ACS Serial number',getdate(), 0, 1,1 ) 
end
if @sname='ACSEEFULRCStart' and substring(@mname,1,4) = '203-'
begin
   insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCStart', @mname, @mname, 'A','Scan in 203 part and ACS Serial number',getdate(), 0, 1,1 ) 
end


if ( substring(@sname,1,11)='QS65FulFill' and @mname = 'QS65B-5110001'  )
begin
   if exists (select station from FFC_EUG_BOM_Level_Station where Station = @sname and @mname = 'QS65B-5110001'  and part_number = '5-2510-02' )
   begin
        delete FFC_EUG_BOM_Level_Station
               where station = @sname and @mname= 'QS65B-5110001'  and part_number = '5-2510-01'
   end
end

-- added on 2/28/2008 by W Kurth per Carl Canavan and Jo Holthe/Doug Sustaire
if @sname='ACSEEFUL2' and @mname  like 'MG10%'
begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='2532-2288'

end

if @sname='ACSEEFUL2' and substring(@mname,1,4) = 'SR60'
begin
   insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in SR60 part and ACS Serial number',getdate(), 0, 1,1 ) 
end
if @sname='ACSEEFULRCStart' and substring(@mname,1,4) = 'SR60'
begin
   insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCStart', @mname, @mname, 'A','Scan in SR60 part and ACS Serial number',getdate(), 0, 1,1 ) 
end

if @sname='ACSP2DPACKAGE' and @mname = '203-751-001'
   begin
        delete FFC_EUG_BOM_Level_station
          where Station=@sname and SAP_Model=@mname and Part_Number='8-0424-03'
   end



-- added on 2/12/2008 per Carl Canavan request
if @sname='FUL3LABEL' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2659'
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number= 'R44-2760'
           end

-- added on 2/12/2008 per Carl Canavan request
if @sname='FUL2PACKAGE' and @mname='669015-001001-0000'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='R44-2671'
           end


if @sname='ACSP2DPACKAGE' and @mname = '203-752-001'
   begin
        delete FFC_EUG_BOM_Level_station
          where Station=@sname and SAP_Model=@mname and Part_Number='8-0481-10'
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

-- added on 1/3/2008 per Jo Holthe request
if @sname='FUL3LABEL' and @mname='MG103012-716-106R'
           begin
		delete BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0681-01'
           end


-- added by W Kurth on 9/26/2007 per Ryan B request
if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4586'
           end

if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete  FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4719'
           end


if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete  FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4585'
           end


if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete  FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4609'
           end


if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete  FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4582'
           end


if @sname='ACSHUYSTART' and ( @mname like '842%' or @mname like '832%')
           begin
		delete  FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='4-4583'            end

-- added 02/272008 by W Kurth
if @sname='ACSEEFULRCSTART' and @mname = 'MG10-PIK-05VR'
begin
    delete FFC_EUG_BOM_Level_Station
             where station=@sname and SAP_Model=@mname and part_number='2532-2288'
end

if @sname='ACSEEFUL2' and @mname = 'MG10-PIK-05VR'
begin
    delete FFC_EUG_BOM_Level_Station
             where station=@sname and SAP_Model=@mname and part_number='2532-2288'
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
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02 '
	end

*/

/*

if @sname = 'ACSEEFULRCSTART' and (substring(@mname,1,3) = 'M22' OR substring(@mname,1,3) = 'M23')
begin
  insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFULRCSTART', @mname, @mname, 'A','Scan in M22 part and ACS Serial number',getdate(), 0, 1,1 ) 

end


if @sname = 'ACSEEFUL2' and (substring(@mname,1,3) = 'M22' OR substring(@mname,1,3) = 'M23')
begin
  insert into FFC_EUG_BOM_Level_Station ( Station, SAP_Model,Part_Number, Rev,Description, BOM_Date_time, ACSEEMode, Qnty, BOMLevel)
   values ( 'ACSEEFUL2', @mname, @mname, 'A','Scan in M22 part and ACS Serial number',getdate(), 0, 1,1 ) 

end
*/
if @sname='ACS4410BACK' and substring(@mname,1,6) = 'F42-15'

	begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='3-0622-02'
	end

if @sname='acsp2dpackage' and @mname = '321-635-001'

	begin
		delete FFC_EUG_BOM_Level_Station
			where Station=@sname and SAP_Model=@mname and Part_Number='8-0424-03'
	end

-- wdk 09/20/06 per Rick Weston
if @sname ='ACSDOSCASEFRONT' and  substring(@mname,1,3) in ( '75-','32X','31X')
begin
    delete FFC_EUG_BOM_Level_Station
           where Station=@sname and SAP_model = @mname and Part_Number in ('6301-0018','6301-0019')
end

-- wdk 02/07/06 for Jo Holthe
if  exists ( select BOMLevel from FFC_EUG_BOM_Level_Station where station = @sname and SAP_Model= @mname and 
Part_Number in ('5-2269-07','5-2269-08','5-2269-09','5-2269-10','5-2269-11','5-2269-12','5-2269-13','5-2269-14','5-2269-15'))
begin
   delete FFC_EUG_BOM_Level_Station
       where station = @sname and SAP_Model=@mname and Part_Number = '5-2164'
end


-- WDK 02222006
/*
if  @sname = 'ACSMAMOUNT' and substring(@mname,1,3) in ('812','822','108','205')
	begin
		update FFC_EUG_BOM_Level_Station set Qnty = 2
			where Station=@sname and SAP_Model=@mname and Part_Number = '6-1011' and Qnty = 3
	end

if  @sname = 'ACSMAMOUNT' and substring(@mname,1,3) in ('811','821','109','206')
	begin
		update FFC_EUG_BOM_Level_Station set Qnty = 1
			where Station=@sname and SAP_Model=@mname and Part_Number = '6-1011' and Qnty = 2
	end
*/

if  exists ( select BOMLevel from FFC_EUG_BOM_Level_Station where station = @sname and SAP_Model= @mname and 
SAP_Model in ('5-2269-07','5-2269-08','5-2269-09','5-2269-10','5-2269-11','5-2269-12','5-2269-13','5-2269-14','5-2269-15'))
begin
   delete FFC_EUG_BOM_Level_Station
       where station = @sname and SAP_Model=@mname and Part_Number = '5-2164'
end

/*   DELETE BOM OVERRIDES AFTER moving assembly to VIPEROPTICSLOAD
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-16')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-14')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-12')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0530-10')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end
*/

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and @sname='ACS4410BACK' and SAP_Model=@mname and SAP_Model in ('F42-14236',

'F42-14234',

'F42-14231'

))
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0622-02 ','3-0622-01')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname  and SAP_Model=@mname and SAP_Model = 'F42-14221')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0622-02' )
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and @sname = 'ACS4410BACK' and SAP_Model=@mname and Part_Number='3-0530-08')
  begin
	delete FFC_EUG_BOM_Level_Station 	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0530-06','3-0530-04','3-0530-02')
  end

--!#@$!#$@#$
-- WDK to take care of two parts for VIPER
/*
if (@sname = 'ViperStart') and (( @mname like '5-2350-%') or ( @mname like '5-2299-%')) 
begin
if   exists(select * from FFC_EUG_BOM_Level_station where station='ViperStart' and part_number='5-1885' )
begin
   insert FFC_EUG_BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from FFC_EUG_BOM_Level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname
end
end
*/

if ( @sname='ViperStart' and @mname like '85%' )
begin
   insert FFC_EUG_BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from FFC_EUG_BOM_Level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname


   insert FFC_EUG_BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from FFC_EUG_BOM_Level_station 
where station='ViperStart' and part_number='5-2764' and sap_model=@mname
end


if ( @sname='ViperStart' and @mname like 'mg%' )
begin
   insert FFC_EUG_BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from FFC_EUG_BOM_Level_station 
where station='ViperStart' and part_number='5-1885' and sap_model=@mname



   insert FFC_EUG_BOM_Level_Station (Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel) 
select Station, SAP_Model, Part_Number, Rev, Description, BOM_Date_Time, ACSEEMode, Qnty, BOMLevel from FFC_EUG_BOM_Level_station 
where station='ViperStart' and part_number='5-2764' and sap_model=@mname
end


if ( @sname = 'ACS4410BACK' and @mname like 'F42-___4_' )
begin
   delete from FFC_EUG_BOM_Level_Station where station=@sname and SAP_Model=@mname and Part_Number in ( '3-0622-02')
end

--if   exists(select BOMLevel from FFC_EUG_BOM_Level_Station where @sname='ViperStart'  and SAP_Model=@mname and sap_model like '5-2350-%' and station='ViperStart')
--begin
--   insert FFC_EUG_BOM_Level_Station select * from FFC_EUG_BOM_Level_station where station='ViperStart'
--end



if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-16')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-14')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-12')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-10')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0504-08')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0504-06','3-0504-04','3-0504-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-22')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-24')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-26')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0521-34')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0521-06','3-0521-04','3-0521-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-24')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-06','3-0542-04','3-0542-02')
  end

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='3-0542-06')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0542-04','3-0542-02')
  end
--- wkurth added 7/22

if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station in ( 'ACSPWPACKAGE',   'FUL2PACKAGE')    and SAP_Model=@mname and Part_Number='820046614' )
   begin
                  update FFC_EUG_BOM_Level_Station set Part_Number = '820027440' 
                        where  Station=@sname and SAP_Model=@mname and Part_Number='820046614'


   end                
                               



if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number='664415-001005-0000')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1530')
  end

-- end of wkurth added 7/22

-- DOS Falcon
if @sname='ACSDOSCASEFRONT'
  begin
	if substring(@mname,1,2) in ('32','31','70','71','72','73','74','75')
	  begin
		delete FFC_EUG_BOM_Level_Station
	   	  where Station=@sname and SAP_Model=@mname and Part_Number in ('0801-1041-05', '0801-1042-00', '6301-0001')
	  end
  end


-- End DOS Falcon

-- FFC BOM override
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1100', 'QS6-2100', 'QS6-4100', 'QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100','QS6-A110'))
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1530')
  end

-- WDK 090605
if exists ( select BOMLevel from FFC_EUG_BOM_Level_Station where Station = @sname and SAP_Model=@mname and Part_Number in ( '7-0204'))
  begin
     delete FFC_EUG_BOM_Level_Station
        where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-1561')
  end
-- WDK


if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and Part_Number in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100', 'QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','667015-020000-0000','668415-019000-0000','668712-014006-0000',
'669019-001001-0000'))
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

if @mname in ('QS6-0000','QS6-0100',
'QS6-1000','QS6-1100','QS6-2000', 'QS6-2100','QS6-4000','QS6-4100', 'QS6-5000','QS6-5100', 'QS6-8000','QS6-8100','QS6-9000','QS6-9100',
'664415-001005-0000','667015-020000-0000','668415-019000-0000','668712-014006-0000',
'669019-001001-0000')
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('R44-2534')
  end

-- or substring(@mname,1,2)='06'
		if substring(@mname,1,2)='PS'
			begin
				if exists(select Part_Number from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname 
					and substring(Part_Number,1,6)='5-1915')
					begin
						delete FFC_EUG_BOM_Level_Station
						where Station=@sname and SAP_Model=@mname and
						    Part_Number in ('7-0768','3-0511-03','5-1107','5-1127','5-1221','5-1327','4-3207-01','4-3203-01',
							'4-3207-03','4-3203-03','4-3207-06','4-3203-02','4-3207-07','4-3207-12','4-3203-05')
					end
			end

	   select FFC_EUG_BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, FFC_EUG_BOM_Level_Station.Rev, FFC_EUG_BOM_Level_Station.Description,
		FFC_EUG_BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
		Partlist.Get_Serial As Part_Type, FFC_EUG_BOM_Level_Station.ACSEEMode, 
		Partlist.Automatic As Display_Option, 
		Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,FFC_EUG_BOM_Level_Station.Qnty,FFC_EUG_BOM_Level_Station.BOMLevel ,
FFC_EUG_BOM_Level_Station.Part_Type as ACS_Part_Type
		from Partlist Inner join Catalog
		on Partlist.Part_No = Catalog.Part_No_Count
		Inner join Stations on Partlist.Station = Stations.Station_Count
		Inner join FFC_EUG_BOM_Level_Station on FFC_EUG_BOM_Level_Station.Part_Number = Catalog.Part_No_Name
		Left Outer Join MappedFileNames on FFC_EUG_BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
		where Stations.Station_Name=@sname and FFC_EUG_BOM_Level_Station.Station=@sname and 
			FFC_EUG_BOM_Level_Station.SAP_Model = @mname 
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
	--	update FFC_EUG_BOM_Level_Station
	--		set Part_Number='R96-XXXX' 	--		where Part_Number='R96-7106'
	--end


--begin BOM override --if substring(@mname,1,3)='5-1' or substring(@mname,1,2)='3-'
--if @mname='09401-02112-05012A'
--begin
  -- update BOM    --set Part_Number='3-0548-02'
     -- where Part_Number='3-0508-08'

--   update BOM
--   set Part_Number='R96-6784'
 --     where Part_Number='R96-6722'

--end
--brutus base station override if @sname='BRUTUSBASE'
   begin
	delete FFC_EUG_BOM_Level_station
	where part_number='R96-6445'
	 and station='BRUTUSBASE'
   end
-- HERE!
-- wk
if @sname in ( 'RhinoFulFillment1' , 'RhinoFulFillment2', 'RhinoFulFillment3')
begin
if exists(select BOMLevel from FFC_EUG_BOM_Level_Station where Station=@sname and SAP_Model=@mname and (Part_Number in
 ('5-1827-10', '5-1827-12','5-1828-10','5-1828-12')))
  begin
	delete FFC_EUG_BOM_Level_Station
	   where Station=@sname and SAP_Model=@mname and Part_Number in ('3-0581-02')
  end
end
-- end wk

	   	select FFC_EUG_BOM_Level_Station.SAP_Model,Catalog.Part_No_Name As Part_Number, FFC_EUG_BOM_Level_Station.Rev, FFC_EUG_BOM_Level_Station.Description,
			FFC_EUG_BOM_Level_Station.BOM_Date_Time, Stations.Station_Name As Station,
			Partlist.Get_Serial As Part_Type, FFC_EUG_BOM_Level_Station.ACSEEMode, 
			Partlist.Automatic As Display_Option,  			Partlist.Disp_Order As Display_Order, MappedFileNames.MappedFileName,FFC_EUG_BOM_Level_Station.Qnty,
FFC_EUG_BOM_Level_Station.BOMLevel ,
FFC_EUG_BOM_Level_Station.Part_Type as ACS_Part_Type
			from Partlist Inner join Catalog
			on Partlist.Part_No = Catalog.Part_No_Count
			Inner join Stations on Partlist.Station = Stations.Station_Count
			Inner join FFC_EUG_BOM_Level_Station on FFC_EUG_BOM_Level_Station.Part_Number = Catalog.Part_No_Name
			Left Outer Join MappedFileNames on FFC_EUG_BOM_Level_Station.Part_Number = MappedFileNames.Part_Number
			where Stations.Station_Name=@sname AND FFC_EUG_BOM_Level_station.Station=@sname and
				FFC_EUG_BOM_Level_Station.SAP_Model = @mname 
		union
		select FFC_EUG_BOM_Level_Station.SAP_Model,FFC_EUG_BOM_Level_Station.Part_Number,FFC_EUG_BOM_Level_Station.Rev,FFC_EUG_BOM_Level_Station.Description,
			FFC_EUG_BOM_Level_Station.BOM_Date_Time, 'Station' as Station,
			'X' as Part_Type, FFC_EUG_BOM_Level_Station.ACSEEMode, 
			'A' as Display_Option, '1' as Display_Order,MappedFileNames.MappedFileName,FFC_EUG_BOM_Level_Station.Qnty,FFC_EUG_BOM_Level_Station.BOMLevel ,
FFC_EUG_BOM_Level_Station.Part_Type as ACS_Part_Type
			 from FFC_EUG_BOM_Level_Station 			Left Outer Join MappedFileNames on FFC_EUG_BOM_Level_Station.Part_Number = MappedFileNames.Part_Number  			where FFC_EUG_BOM_Level_Station.Station=@sname and FFC_EUG_BOM_Level_Station.SAP_Model = @mname and ((  substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'R96' 
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,4) = 'INFO' 
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'ERS'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'R56'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XBL'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'X96'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XLA'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XLB'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XHA'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XHB'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,2)='62'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,2) = 'eb'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,2) = 'nk'
			or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XVA' 
                                         or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) = 'XTA' 
                                         or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,2) = 'DR'
                                          or substring(FFC_EUG_BOM_Level_Station.Part_Number,1,3) ='610'  )

or
                                         (
                                           substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='A' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,2)='AR' 
                                          or substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='B' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,2)='BA' 
                                          or substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='C' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,2)='CA'
                                          or substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='D' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='E' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,1)='F' 
                                           or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,2)='AL' 
                                          or  substring(FFC_EUG_BOM_Level_Station.Part_Type,1,2)='BL' 


 
                                        )
                                    )

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