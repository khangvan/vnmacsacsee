SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TestSE1500]
@SN char(9) OUTPUT
 AS
	set nocount on
	declare @count int
	declare @countModel int
	declare @stamp datetime
	declare @SerialType char(1)
	declare @MCType char(1)
	declare @DatePart char(5)
	declare @Temp char(10)
	declare @NumDays int
	declare @strNumDays char(3)
	declare @LastDate datetime
	declare @LastModelDate datetime
	declare @DateImbeddedCounter char(8)
	declare @ModelImbeddedCounter char(3)
	declare @CustomFormat char(20)

             declare @endsn char(20)
	-- Initialize variables
	set @count =0
	set @stamp = getdate()
	set @ModelImbeddedCounter='000'
	set @DateImbeddedCounter='00000000'

	begin transaction
	-- Increment Counter for code in the Counters db
	select 
		@SerialType = Imbedded_Date,
		@count = Counter + 1,
		@LastDate = Last_Event_Date,
		@MCType = Imbedded_ModelCounter,
		@CustomFormat = strFormat
	from 
		[ACSEESTATE].dbo.Serialization (updlock)
	where  
		(Prefix_Type = 'ACS')
		and
		(Prefix = '8') -- Last_foo_Count
	if @@ERROR <> 0
	   Begin
		Rollback
		select 'Error Reading counter'
		return 
	   End

	--Check the date to see if counter needs to be set to zero first
	if @LastDate is not null and (@SerialType is not null and @SerialType <> '0' and @SerialType <>'N')
	   begin
		if datediff(dd, @LastDate, @stamp) > 0
		   begin
			set @count = 1
		   end
	   end

	--perform updates
	update
		[ACSEESTATE].dbo.Serialization
	set
		Counter = @count,
		Last_Event_Date = @stamp
	where  
		(Prefix_Type = 'ACS')
		and
		(Prefix = '8') -- Last_foo_Count

	if @@ERROR <> 0
	   	Begin
			Rollback		
			select 'Error updating counter'
			Return
	   	End
	else
		begin
			Commit
                                        set @endsn = 'S80' +convert(char(10), @count)
			select @endsn
			set @SN = @endsn	
		end

	--if type is ACS then increment model number counter
	--Note: 'YY' is the acs serial prefix at ACSMATOP which is a station used to see which 5- are required for a mamba top model - so it 'starts' a
	--         top model - but it's not on the main line so we don't want it affecting the counter
/*
	if (@PrefixType='ACS') and (@Prefix<>'YY')
	   begin
		--@SAPModel
		if exists (select Counter from dbo.ModelDailyCounter
			where SAP_Model_Name=@SAPModel)
		   begin
			select @LastModelDate=Last_Event_Date, @countModel=Counter from dbo.ModelDailyCounter
				where SAP_Model_Name=@SAPModel

			--see if it is a new day and see if it is after 2am --and (datepart(hh,getdate()) >2)
			if (datediff(dd, @LastModelDate, @stamp) > 0) 
		   	   begin
				if datepart(hh,@stamp)>=2
				  begin
					--reset counter at midnight -- now 2am
					set @countModel = 1
				  end
		   	   end
			else
			   begin
		   		set @countModel = @countModel +1
			   end
			
			update dbo.ModelDailyCounter
			set Counter=@countModel, Last_Event_Date=@stamp
			where SAP_Model_Name=@SAPModel
		   end
		else
		   begin
			insert dbo.ModelDailyCounter
			values(@SAPModel,1,@stamp)
			set @countModel=1
		   end

		if @countModel<10
		   begin
			set @ModelImbeddedCounter = '00'+str(@countModel,1,0)
		   end
		else
		   begin
			if @countModel<100
			   begin
				set @ModelImbeddedCounter = '0'+str(@countModel,2,0)
			   end
			else
			   begin
				set @ModelImbeddedCounter = str(@countModel, 3, 0)
			   end
	   	   end
	   end

	--post processing
	if @SerialType is null or @SerialType = '0' or @SerialType='N'
	  begin
		--Normal/counter type serial number
		select 
			@PrefixType as Prefix_Type,
			@Prefix as Prefix,
			@count as 'Counter',
			@ModelImbeddedCounter as 'CounterModel',
			@SerialType as 'Imbedded_Date',
			@MCType as 'Imbedded_ModelCounter',
			@CustomFormat as 'strFormat'
	   end
	else
	   begin
		--Imbedded Date Serail number (YYDDDNNN)
		--First get the date part (YYDDD)
		set @Temp = convert(char(6), @stamp, 112) --Get ISO Date and take first two digits
		set @NumDays = datepart(dy, @stamp)
		if @NumDays < 10
		   begin
			set @strNumDays = '00' + str(@NumDays, 1, 0)
		   end
		else
		   begin
			if @NumDays < 100
			   begin
				set @strNumDays = '0' + str(@NumDays, 2, 0)
			   end
			else
			   begin
				set @strNumDays = str(@NumDays, 3, 0)
			   end
		   end
		set @DatePart = substring(@Temp, 3, 2) + @strNumDays
		--Now get the counter part (NNN)
		if @count < 10
		   begin
			set @DateImbeddedCounter = @DatePart + '00' + str(@count, 1, 0)
		   end
		else
		   begin
			if @count < 100
			   begin
				set @DateImbeddedCounter = @DatePart + '0' + str(@count, 2, 0)
			   end
			else
			   begin
				set @DateImbeddedCounter = @DatePart + str(@count, 3, 0)
			   end
		   end			  
		--select @DateImbeddedCounter
		select 
			@PrefixType as Prefix_Type,
			@Prefix as Prefix,
			@DateImbeddedCounter as 'Counter',
			@ModelImbeddedCounter as 'CounterModel',
			@SerialType as 'Imbedded_Date',
			@MCType as 'Imbedded_ModelCounter',
			@CustomFormat as 'strFormat'
	   end
*/
GO