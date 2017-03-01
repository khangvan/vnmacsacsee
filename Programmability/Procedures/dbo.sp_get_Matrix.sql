SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

create proc [dbo].[sp_get_Matrix]
-- Define input parameters
	@mname		char(20) = NULL
	-- Define code
AS
	--Define local variable(s)
	declare @cable nvarchar(40)
	declare @brick nvarchar(40)
	declare @country nvarchar(40)
	declare @config nvarchar(40)
	declare @EAS nvarchar(40)
	declare @custom nvarchar(40)
	declare @scale nvarchar(40)
	
	declare @class char(5)
	declare @Istart int
	declare @Ilen int
	declare @digits char(5)


	--Verify that non-NULLable parameter(s) have values
	if @mname is NULL
	   begin
		/*raiserror(50011,10,1,'1.1700','Part Name')*/
		return
	   end

	
	--See if 3 digit class exists
	set @class = substring(@mname,1,3)
	if not exists(select class from ParseInit
		where class =@class)
	   begin
		set @class = substring(@mname,1,4)
		if not exists(select class from ParseInit
			where class = @class)
		   begin
			/*raiseerror */
			return
		   end
	   end

	/* Now that we have the @class, let's get @config */
	select @Istart=configstart from ParseInit
		where class=@class
	select @Ilen=configlength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @config = value from Config
		where (class=@class)and(digits=@digits)
	if @config is null
		begin
			set @config = "NA"
		end

	/* Now let's get @custom */
	select @Istart=customstart from ParseInit
		where class=@class
	select @Ilen=customlength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @custom = value from Custom
		where (class=@class)and(digits=@digits)
	if @custom is null
		begin
			set @custom = "NA"
		end

	/* Now let's get @country */
	select @Istart=country from ParseInit
		where class=@class
	select @Ilen=countrylength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @country = value from Country
		where (class=@class)and(digits=@digits)
	if @country is null
		begin
			set @country = "NA"
		end

	/* Now let's get @scale */
	select @Istart=scale from ParseInit
		where class=@class
	select @Ilen=scalelength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)

	select @scale = value from Scale
		where (class=@class)and(digits=@digits)
	if @scale is null
		begin
			set @scale="SCAN ONLY"
		end

	/* Now let's get @brick */
	select @Istart=brick from ParseInit
		where class=@class
	select @Ilen=bricklength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @brick = value from Brick
		where (class=@class)and(digits=@digits)
	if @brick is null
		begin
			set @brick = "NA"
		end

	/* Now let's get @cable */
	select @Istart=cable from ParseInit
		where class=@class
	select @Ilen=cablelength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @cable = value from Cables
		where (class=@class)and(digits=@digits)
	if @cable is null
		begin
			set @cable = "NA"
		end

	/* Now let's get @EAS */
	select @Istart=EAS from ParseInit
		where class=@class
	select @Ilen=EASlength from ParseInit
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @EAS = value from EAS
		where (class=@class)and(digits=@digits)
	if @EAS is null
		begin
			set @EAS = "NA"
		end

	select @mname As SAP_Model, @config As Configuration, @custom as Custome, 
		@country As Country, @scale As Scale, @brick As Brick,
		@cable As Cables, @EAS As EAS

/*
'	select BOM.SAP_Model, BOM.Part_Number, BOM.Rev, BOM.Description,BOM.BOM_Date_Time,
'		BOM.ACSEEMode from Partlist Inner join Catalog
'		on Partlist.Part_No = Catalog.Part_No_Count
'		Inner join Stations on Partlist.Station = Stations.Station_Count
'		Inner join BOM on BOM.Part_Number = Catalog.Part_No_Name
'		where Stations.Station_Name=@sname AND BOM.SAP_Model = @mname
'		order by BOM.Part_Number
*/
-- Create the Stored Procedure

GO