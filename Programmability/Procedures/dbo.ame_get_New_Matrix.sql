SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO


CREATE proc [dbo].[ame_get_New_Matrix]
-- Define input parameters
	@mname		char(20) = NULL
	-- Define code
AS
	--Define local variable(s)
	declare @LabelFormatPrefix nvarchar(10)
	declare @FormatTypeByte int
	declare @SModel nvarchar(40)
	declare @Power nvarchar(40)
	declare @Interface nvarchar(40)
	declare @Config nvarchar(40)
	declare @Top nvarchar(40)
	declare @SInterface nvarchar(40)
	declare @Scale nvarchar(40)
	declare @Option_0 nvarchar(40)
	declare @Option_1 nvarchar(40)
	declare @Option_2 nvarchar(40)
	declare @Option_3 nvarchar(40)
	declare @Option_4 nvarchar(40)
	declare @Option_5 nvarchar(40)
	declare @Option_6 nvarchar(40)
	declare @Option_7 nvarchar(40)
	declare @Option_8 nvarchar(40)
	declare @Option_9 nvarchar(40)
	
	declare @class char(5)
	declare @Istart int
	declare @Ilen int
	declare @digits char(5)

	--Verify that non-NULLable parameter(s) have values
	if @mname is NULL
	   begin
		/*raiserror(50011,10,1,'1.1700','Part Name')*/
		select 'Error: You must specify an SAP Model Number'
		return
	   end
	
	--See if 3 digit class exists
	set @class = substring(@mname,1,4)
	if not exists(select class from  dbo.Matrix_Parsing
		where class =@class)
	   begin
		set @class = substring(@mname,1,3)
		if not exists(select class from  dbo.Matrix_Parsing
			where class = @class)
		   begin
			select 'NA'
			return
		   end
	   end

	/* Fill in the format file */
	select @Istart=Format_File_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Format_File_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @LabelFormatPrefix = Label_Format_Prefix from dbo.Format_File
		where (class=@class)and(digits=@digits)
	if @LabelFormatPrefix is null
		begin
			set @LabelFormatPrefix = "NA"
		end
	select @FormatTypeByte = Type_Byte from dbo.Format_File
		where (class=@class)and(digits=@digits)
	if @FormatTypeByte is null
		begin
			set @FormatTypeByte = 0
		end

	/* Now that we have the @SModel */
	select @Istart=SModel_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=SModel_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @SModel = Matrix_Value from dbo.SModel
		where (class=@class)and(digits=@digits)
	if @SModel is null
		begin
			set @SModel = "NA"
		end

	/* Now that we have the @Power */
	select @Istart=Power_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Power_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Power = Matrix_Value from dbo.[Power]
		where (class=@class)and(digits=@digits)
	if @Power is null
		begin
			set @Power = "NA"
		end

	/* Now let's get @Interace */
	select @Istart=Interface_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Interface_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Interface = Matrix_Value from dbo.Interface
		where (class=@class)and(digits=@digits)
	if @Interface is null
		begin
			set @Interface = "NA"
		end

	/* Now let's get @Config */
	select @Istart=Config_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Config_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Config = Matrix_Value from dbo.Config
		where (class=@class)and(digits=@digits)
	if @Config is null
		begin
			set @Config = "NA"
		end

	/* Now let's get @Top */
	select @Istart=Top_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Top_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Top = Matrix_Value from dbo.[Top]
		where (class=@class)and(digits=@digits)
	if @Top is null
		begin
			set @Top = "NA"
		end

	/* Now let's get @Interace */
	select @Istart=SInterface_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=SInterface_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @SInterface = Matrix_Value from dbo.SInterface
		where (class=@class)and(digits=@digits)
	if @SInterface is null
		begin
			set @SInterface = "NA"
		end

	/* Now let's get @Scale */
	select @Istart=Scale_start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Scale_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)

	select @scale = Matrix_Value from dbo.Scale
		where (class=@class)and(digits=@digits)
	if @scale is null
		begin
			set @scale="SCAN ONLY"
		end

	/* Now let's get @Option_0 */
	select @Istart=Option_0_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_0_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_0 =Matrix_Value from dbo.Option_0
		where (class=@class)and(digits=@digits)
	if @Option_0 is null
		begin
			set @Option_0 = "NA"
		end
		
	/* Now let's get @Option_1 */
	select @Istart=Option_1_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_1_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_1 =Matrix_Value from dbo.Option_1
		where (class=@class)and(digits=@digits)
	if @Option_1 is null
		begin
			set @Option_1 = "NA"
		end

	/* Now let's get @Option_2 */
	select @Istart=Option_2_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_2_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_2 =Matrix_Value from Option_2
		where (class=@class)and(digits=@digits)
	if @Option_2 is null
		begin
			set @Option_2 = "NA"
		end

	/* Now let's get @Option_3 */
	select @Istart=Option_3_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_3_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_3 =Matrix_Value from dbo.Option_3
		where (class=@class)and(digits=@digits)
	if @Option_3 is null
		begin
			set @Option_3 = "NA"
		end

	/* Now let's get @Option_4 */
	select @Istart=Option_4_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_4_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_4 =Matrix_Value from dbo.Option_4
		where (class=@class)and(digits=@digits)
	if @Option_4 is null
		begin
			set @Option_4 = "NA"
		end

	/* Now let's get @Option_5 */
	select @Istart=Option_5_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_5_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_5 =Matrix_Value from dbo.Option_5
		where (class=@class)and(digits=@digits)
	if @Option_5 is null
		begin
			set @Option_5 = "NA"
		end

	/* Now let's get @Option_6 */
	select @Istart=Option_6_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_6_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_6 =Matrix_Value from dbo.Option_6
		where (class=@class)and(digits=@digits)
	if @Option_6 is null
		begin
			set @Option_6 = "NA"
		end

	/* Now let's get @Option_7 */
	select @Istart=Option_7_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_7_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_7 =Matrix_Value from dbo.Option_7
		where (class=@class)and(digits=@digits)
	if @Option_7 is null
		begin
			set @Option_7 = "NA"
		end

	/* Now let's get @Option_8 */
	select @Istart=Option_8_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_8_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_8 =Matrix_Value from dbo.Option_8
		where (class=@class)and(digits=@digits)
	if @Option_8 is null
		begin
			set @Option_8 = "NA"
		end

	/* Now let's get @Option_9 */
	select @Istart=Option_9_Start from  dbo.Matrix_Parsing
		where class=@class
	select @Ilen=Option_9_length from  dbo.Matrix_Parsing
		where class=@class
	set @digits = substring(@mname,@Istart,@Ilen)
	select @Option_9 =Matrix_Value from dbo.Option_9
		where (class=@class)and(digits=@digits)
	if @Option_9 is null
		begin
			set @Option_9 = "NA"
		end
	select 'OK'
	select @mname As SAP_Model, @LabelFormatPrefix As Label_Format_Prefix, @FormatTypeByte as Format_Type_Byte, 
		@SModel As SModel, @Power As Power_Var ,@Interface as Interface, @Config as Config, @Top as [Top],
		@SInterface as SInterface, @Scale As Scale, @Option_0 As Option_0, @Option_1 As Option_1,
		@Option_2 As Option_2,@Option_3 As Option_3,@Option_4 As Option_4,@Option_5 As Option_5,
		@Option_6 As Option_6,@Option_7 As Option_7,@Option_8 As Option_8,@Option_9 As Option_9
-- Create the Stored Procedure

GO