SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE proc [dbo].[ame_get_Reconfig_BOM_Level]
-- Define input parameters
	@sname 		char(20) = NULL,
	@mname		char(20) = NULL

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

	
	   select BOM_Level.SAP_Model,BOM_Level.Part_Number As Part_Number, BOM_Level.Rev, BOM_Level.Description,
		BOM_Level.BOM_Date_Time, @sname As Station,
		'N' As Part_Type, BOM_Level.ACSEEMode, 
		'N' As Display_Option, 
		1 As Display_Order, part_number as MappedFileName,BOM_Level.Qnty,BOM_Level.BOMLevel 
		from BOM_Level
		where  BOM_Level.SAP_Model = @mname and acseemode=0 and part_number like '3-%'
		Order by bom_level.part_number
		return
GO