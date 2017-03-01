SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



/*

exec [user_check_SerialModel_khangtest] '740175000','SK100991054'
exec [[user_check_SerialModel_khangtest]] '700010700','SVA000842898'

*/

CREATE  PROCEDURE [dbo].[user_check_SerialModel_khangtest]
	@Model char(30) = NULL,
	@Serial char(30) = NULL
	
AS
	set nocount on

	declare @result char(200)
	declare @Model1 char(30)
	declare @Modelcorrect char(30)
	declare @lasttlid int	
	declare @dt datetime
	declare @passfail char(1)
	declare @doubleTestid int
	declare @station char(20)

	
	select @dt = max(Test_Date_Time)  -- Khang add to get testdatetime
	from testlog 
	where ACS_Serial = @Serial

	select TOP  1 @Modelcorrect=sap_model 	from testlog 
	where ACS_Serial = @Serial

	if (rtrim(ltrim(@Model)) = '700101701')
	begin
		set @Model='700234601'
	END

	if (rtrim(ltrim(@Model)) = '700101702')
	begin
		set @Model='700234602'
	end

	if (rtrim(ltrim(@Model)) = '700072600')
	begin
		set @Model='700008600'
	end
	if (rtrim(ltrim(@Model)) = '700101700')
	begin
		set @Model='700057900'
	end

	if (rtrim(ltrim(@Model)) = '728725-001' or rtrim(ltrim(@Model))='891000080')
	begin
		set @result = 'OK'	
		select @result as Result
		return
	end

	if (ltrim(rtrim(@Model))=ltrim(rtrim(@Serial)))
	begin
		set @result = 'Model=Serial'	
--		insert VNCheckPassFailRecord (Model,Serial,Result,TestDateTime) values(@Model,@Serial,@result,getdate())		
		select @result as Result
		return
	end

	if (left(rtrim(ltrim(@Serial)),2)='SE')
	begin
		if exists (select ACS_Serial from [ACSEEState].dbo.locilog where next_Station_name='ACSVNSE1500PACK' and PSC_Serial=@Serial)
		begin
			select @Serial=ACS_Serial from [ACSEEState].dbo.locilog where next_Station_name='ACSVNSE1500PACK' and PSC_Serial=@Serial
		end
		else
		begin
			set @result = 'NoData'	
--			insert VNCheckPassFailRecord (Model,Serial,Result,TestDateTime) values(@Model,@Serial,@result,getdate())	
			select @result as Result
			return
		end
	end

 --TM Models
	if substring(@Model,1,2)='74' or substring(@Model,1,1)='5' 
	begin
		if exists ( select acs_serial from [ACSEEState].[dbo].loci where acs_serial = @Serial  and sap_model=@Model and next_station_name='ACSVNONESTART')
		begin
			set @result = 'OK' -- found loci entry at start station
		end
		else
		begin
			set @result='Fail'  -- didn't find any loci entry at start station

			

		end
	end
	else
	begin
		if exists ( select acs_serial from  [ACSEEState].[dbo].loci where acs_serial=@Serial and sap_model=@Model and next_station_name='TMPostTest')
		begin
			set @result = 'OK' -- found loci entry at TMPostTest
		end
		else
		begin
			set @result='Fail'  -- didn't find any loci entry at TMPostTest
		end
	end
	--set @result='Fail'

	if (@result='Fail')  -- no loci entry was found so I have to look some where else
	BEGIN

		if not exists (select SAP_Model from testlog where ACS_Serial=@Serial and (Station not like 'G2DPOWER%' and Station not like 'DRAGONLCAL%' and Station not like 'HAWKEYERFBASE%'))
		begin
			set @result = 'NoData'	
	--		insert VNCheckPassFailRecord (Model,Serial,Result,TestDateTime) values(@Model,@Serial,@result,getdate())	
		end
		else
		begin
			if not exists (select SAP_Model from testlog where ACS_Serial=@Serial and SAP_Model=@Model and (Station not like 'G2DPOWER%' and Station not like 'DRAGONLCAL%' and Station not like 'HAWKEYERFBASE%'))
			begin
				set @result = 'ModelIncorrect|'+@Modelcorrect
	--			insert VNCheckPassFailRecord (Model,Serial,Result,TestDateTime) values(@Model,@Serial,@result,getdate())	
			end
			else
			begin
				--if exists ( select acs_serial from [ACSEEState].[dbo].loci where acs_serial = @Serial  and sap_model=@Model and (next_station_name='ACSVNONESTART' or next_station_name='TMPOSTTEST'))
				--begin
				--	set @result = 'OK'
				--end
				--else
				--begin
					select @doubleTestid= max(DT_id) from TM_DoubleTestTable where DT_Model=@Model
					if @doubleTestid is null
					begin
						select @dt = max(Test_Date_Time) from testlog where ACS_Serial = @Serial 
						select @lasttlid = max(TL_ID) from testlog where Test_Date_Time=@dt and ACS_Serial = @Serial
						select @passfail=Pass_Fail,@station=Station,@Model1=SAP_Model from testlog where TL_ID=@lasttlid
					----k add
							if ((left(rtrim(ltrim(@station)),9)='ACSEEORT7'))
								begin
								select @Model1=SAP_Model from testlog where SAP_Model = @Model and ACS_Serial = @Serial and Station not like @station
									--set @Model1
								END

	
					----k add	

						if (rtrim(ltrim(@Model1)) <> rtrim(ltrim(@Model)))
						begin
							
									set @result = 'ModelIncorrect'
								
							
						end
						else
						begin
							if (rtrim(ltrim(@passfail))='P')
							begin
								if (left(rtrim(ltrim(@station)),8)='G2DPOWER') or (left(rtrim(ltrim(@station)),10)='DRAGONLCAL') or (left(rtrim(ltrim(@station)),13)='HAWKEYERFBASE' )
								begin
									if exists (select Station from testlog where SAP_Model = @Model and ACS_Serial = @Serial and Station not like @station)
									begin
										set @result = 'OK'
									end
									else
									begin
										set @result = 'Fail'
									end
								end
								else
								begin
									set @result = 'OK' -- pass test data

									--check test for Mosaic
		
;WITH CTE
as
(
	SELECT SUBSTRING(station,0,len(station)) AS Stationthrough
	,      pass_fail
	,      max(test_date_time) AS testdate
	FROM testlog
	WHERE acs_serial = @Serial AND SAp_model =@Model
		and pass_fail = 'P' and (station LIKE 'MOSAICPRECHECK[12345]' OR station LIKE 'MOSAICPERF[12345]')
	--and NOT tl_id =57489909
	GROUP BY SUBSTRING(station,0,len(station))
	,        pass_fail
)
SELECT @result= CASE WHEN count (*) = 1 then 'Fail'--'FAIL-DATA TEST'
                     WHEN count (*) > 1 then 'OK'--'PASS-DATATEST'
-- WHEN count (*) = NULL then 'NoData'
                                        ELSE 'OK'--'NO-check' Do nothing
END
FROM CTE


		--check test for Mosaic

		--check test for HAlogen
		
;WITH CTE
as
(
	SELECT SUBSTRING(station,0,len(station)) AS Stationthrough
	,      pass_fail
	,      max(test_date_time) AS testdate
	FROM testlog
	WHERE acs_serial = @Serial AND SAp_model =@Model
		and pass_fail = 'P' and (station LIKE 'HALOFOCUS[12345]' OR station LIKE 'HLGUNTEST1i[12345]')
	--and NOT tl_id =57489909
	GROUP BY SUBSTRING(station,0,len(station))
	,        pass_fail
)
SELECT @result= CASE WHEN count (*) = 1 then 'Fail'--'FAIL-DATA TEST'
                     WHEN count (*) > 1 then 'OK'--'PASS-DATATEST'
-- WHEN count (*) = NULL then 'NoData'
                                        ELSE 'OK'--'NO-check' Do nothing
END
FROM CTE


		--check test for HAlogen

		--- check for usb
		if( @dt > '12/06/2016 14:00:00') -- start check from shift 2
			begin

DECLARE	@return_table TABLE (Result varchar(200))
DECLARE @KQ varchar(200)

INSERT into @return_table  EXEC  [dbo].[amevn_SerialCheckUSB] @Serial

set @KQ =(SELECT	TOP 1 * FROM @return_table) 
--SELECT SUBSTRING(@KQ,1,2) AS result


IF (SUBSTRING(@KQ,1,2) ='OK')
    begin
    set @result = 'OK'
    end
ELSE IF  (SUBSTRING(@KQ,1,2) ='NG')
    begin
    set @result = 'Fail'+@KQ
    END
    
    end
		--- check for usb end
			
			
								end
							end
							ELSE -- (rtrim(ltrim(@passfail))='F')
							begin
								set @result = 'Fail'
							end				
						end
					end
					else
					begin
							set @result = 'Fail'
					--		--temp set- for seting loci fail Halogen NA - Khang Close 29 Apr 2016
					--	if exists ( select acs_serial from [acs ee].dbo.testlog where acs_serial = @Serial  and sap_model='740045100' and station='HLGUNTEST1i1' and Pass_Fail ='P')
					--begin
					--	set @result = 'OK' 
					--END
					--temp set
					end		
				--end
			end
		END

		

	END

	--IF (getdate()< '08/15/2016') >>> Huy extended to 19/Aug on 18/Aug
	IF (getdate()< '08/19/2016')
	BEGIN
	IF (@Model ='700234602')
	-- do nothing
	set @result = 'OK'
	set @dt = DATEADD(dd,-7,getdate())
	IF (@Model ='700234601')
	-- do nothing
	set @result = 'OK'
	set @dt = DATEADD(dd,-7,getdate())
	end

	--set @result='OK'
	select @result as Result
----debug
--	declare @dttest datetime
--	set @dttest= @dt
--	select @dttest as TestDateTimeTest
------debug end
--	set @dt = '08/04/2015' -- check rồi remove
	select @dt as TestDateTime
	--return


	/*
	Debug StoreProcedure

select max(Test_Date_Time) from testlog where acs_serial ='g15habtyd'
debug aug 5 cho thinh tst model 
exec user_check_SerialModel '700101702', 'SP001576969'
	
	*/
GO