SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO


CREATE proc [dbo].[ame_get_Legacy_Matrix]
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
	if not exists(select class from dbo.Matrix_Parsing
		where class =@class)
	   begin
		set @class = substring(@mname,1,4)
		if not exists(select class from dbo.Matrix_Parsing
			where class = @class)
		   begin
			/*raiseerror */
			return
		   end
	   end

	/* Now that we have the @class, let's get @config */
	select @Istart=Option_2_Start from dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_2_length from dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @config = Matrix_Value from Option_2
		where (class=@class)and(digits=@digits)
	if @config is null
		begin
			set @config = "NA"
		end

	/* Now let's get @custom */
	select @Istart=SModel_start from dbo.Matrix_Parsing
		where class=@class
	select @Ilen=SModel_length from dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @custom = Matrix_Value from dbo.SModel
		where (class=@class)and(digits=@digits)
	if @custom is null
		begin
			set @custom = "NA"
		end

	--Country is no longer used
	set @country = "NA"
	
	/* Now let's get @scale */
	select @Istart=Scale_start from dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Scale_length from dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)

	select @scale = Matrix_Value from dbo.Scale
		where (class=@class)and(digits=@digits)
	if @scale is null
		begin
			set @scale="SCAN ONLY"
		end

	set @brick = "NA"
	
	/* Now let's get @cable */
	select @Istart=Option_1_Start from dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_1_length from dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @cable =Matrix_Value from dbo.Option_1
		where (class=@class)and(digits=@digits)
	if @cable is null
		begin
			set @cable = "NA"
		end

	set @EAS = "NA"
	
	select @mname As SAP_Model, @config As Configuration, @custom as Custome, 
		@country As Country, @scale As Scale, @brick As Brick,
		@cable As Cables, @EAS As EAS

-- Create the Stored Procedure

GO