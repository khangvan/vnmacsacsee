SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[ame_check_dataFFCSoft]
	@TopModel char(30) = '',
	@TestStation char(30) = '',
	@Model1 char(30) = '',
	@Model2 char(30) = '',
	@LabelSN char(30) = '',
	@LabelBASE char(30) = '',
	@LabelBOX char(30) = '',
	@LabelPAT char(30) = ''

AS
	set nocount on

	declare @rTopModel char(3)
	declare @rTopModelLimits char(3)
	declare	@rModel1 char(3) 
	declare	@rModel2 char(3) 
	declare	@rLabelSN char(3)
	declare	@rLabelBASE char(3)
	declare	@rLabelBOX char(3) 
	declare	@rLabelPAT char(3) 
	
	declare @sname char(20)
	declare @scount int

	set @rTopModel ='NGP'
	set @rTopModelLimits ='NGP'
	set @rModel1 ='NGP'
	set @rModel2 ='NGP'
	set @rLabelSN ='NGP'
	set @rLabelBASE ='NGP'
	set @rLabelBOX ='NGP'
	set @rLabelPAT ='NGP' 

	if exists (select tffc_kicker_model from tffc_kicker_table where tffc_kicker_model=@TopModel)
	begin
		set @rTopModel='OK'
	end
	else
	begin
		set @rTopModel='NG'
	end

	if exists (select sap_model_name from subtestlimits where sap_model_name=@TopModel and station_name=@TestStation)
	begin
		set @rTopModelLimits='OK'
	end
	else
	begin
		set @rTopModelLimits='NG'
	end

	if exists (select tffc_kicksub_model from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model1)
	begin
		set @rModel1='OK'
	end
	else
	begin
		set @rModel1='NG'
	end

	if exists (select tffc_kicksub_model from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model2)
	begin
		set @rModel2='OK'
	end
	else
	begin
		set @rModel2='NG'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelSN)
	begin
		set @rLabelSN='OK'
	end
	else
	begin
		set @rLabelSN='NG'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelBASE)
	begin
		set @rLabelBASE='OK'
	end
	else
	begin
		set @rLabelBASE='NG'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelBOX)
	begin
		set @rLabelBOX='OK'
	end
	else
	begin
		set @rLabelBOX='NG'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelPAT)
	begin
		set @rLabelPAT='OK'
	end
	else
	begin
		set @rLabelPAT='NG'
	end

	declare	@rACS1Model1 char(3) 
	declare	@rACS1Model2 char(3) 
	declare	@rACS2Model1 char(3) 
	declare	@rACS2Model2 char(3) 
	declare	@rACS1LabelSN char(3)
	declare	@rACS2LabelSN char(3)
	declare	@rACS3LabelSN char(3)
	declare	@rACS1LabelBASE char(3)
	declare	@rACS2LabelBASE char(3)
	declare	@rACS3LabelBASE char(3)
	declare	@rACS1LabelBOX char(3) 
	declare	@rACS2LabelBOX char(3) 
	declare	@rACS3LabelBOX char(3) 
	declare	@rACS1LabelPAT char(3) 
	declare	@rACS2LabelPAT char(3) 
	declare	@rACS3LabelPAT char(3) 

	set @rACS1Model1 ='NGP'
	set @rACS1Model2 ='NGP'
	set @rACS2Model1 ='NGP'
	set @rACS2Model2 ='NGP'
	set @rACS1LabelSN ='NGP'
	set @rACS2LabelSN ='NGP'
	set @rACS3LabelSN ='NGP'
	set @rACS1LabelBASE ='NGP'
	set @rACS2LabelBASE ='NGP'
	set @rACS3LabelBASE ='NGP'
	set @rACS1LabelBOX ='NGP'
	set @rACS2LabelBOX ='NGP'
	set @rACS3LabelBOX ='NGP'
	set @rACS1LabelPAT ='NGP' 
	set @rACS2LabelPAT ='NGP'
	set @rACS3LabelPAT ='NGP'

	set @sname='ACSVNDALIFFCST'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists	(select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model1)
	begin
		set @rACS1Model1='OK'
	end
	else
	begin
		set @rACS1Model1='NG'
	end

	if exists	(select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model2)
	begin
		set @rACS1Model2='OK'
	end
	else
	begin
		set @rACS1Model2='NG'
	end

	set @sname='ACSVNONESTART'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists	(select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model1)
	begin
		set @rACS2Model1='OK'
	end
	else
	begin
		set @rACS2Model1='NG'
	end

	if exists	(select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model2)
	begin
		set @rACS2Model2='OK'
	end
	else
	begin
		set @rACS2Model2='NG'
	end

	set @sname='ACSVNFFCDALILBL'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN)
	begin
		set @rACS1LabelSN='OK'
	end
	else
	begin
		set @rACS1LabelSN='NG'
	end

	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE)
	begin
		set @rACS1LabelBASE='OK'
	end
	else
	begin
		set @rACS1LabelBASE='NG'
	end

	set @sname='ACSVNONELABEL'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN)
	begin
		set @rACS2LabelSN='OK'
	end
	else
	begin
		set @rACS2LabelSN='NG'
	end

	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE)
	begin
		set @rACS2LabelBASE='OK'
	end
	else
	begin
		set @rACS2LabelBASE='NG'
	end

	set @sname='ACSVNTWOLABEL'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN)
	begin
		set @rACS3LabelSN='OK'
	end
	else
	begin
		set @rACS3LabelSN='NG'
	end
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE)
	begin
		set @rACS3LabelBASE='OK'
	end
	else
	begin
		set @rACS3LabelBASE='NG'
	end

	set @sname='ACSVNFFCDALIBOX'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX)
	begin
		set @rACS1LabelBOX='OK'
	end
	else
	begin
		set @rACS1LabelBOX='NG'
	end
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT)
	begin
		set @rACS1LabelPAT='OK'
	end
	else
	begin
		set @rACS1LabelPAT='NG'
	end

	set @sname='ACSVNONEBOX'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX)
	begin
		set @rACS2LabelBOX='OK'
	end
	else
	begin
		set @rACS2LabelBOX='NG'
	end

	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT)
	begin
		set @rACS2LabelPAT='OK'
	end
	else
	begin
		set @rACS2LabelPAT='NG'
	end

	set @sname='ACSVNTWOBOX'
	select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX)
	begin
		set @rACS3LabelBOX='OK'
	end
	else
	begin
		set @rACS3LabelBOX='NG'
	end

	if exists (select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT)
	begin
		set @rACS3LabelPAT='OK'
	end
	else
	begin
		set @rACS3LabelPAT='NG'
	end

	select @rTopModel as TopModel, @rTopModelLimits as TopModelLimits, @rModel1 as Model1,
		@rModel2  as Model2, @rLabelSN as LabelSN, @rLabelBASE as LabelBASE,
		@rLabelBOX as LabelBOX, @rLabelPAT as LabelPAT, @rACS1Model1 as ACS1Model1,
		@rACS1Model2 as ACS1Model2, @rACS2Model1 as ACS2Model1, @rACS2Model2 as ACS2Model2,
		@rACS1LabelSN as ACS1LabelSN,@rACS2LabelSN as ACS2LabelSN,@rACS3LabelSN as ACS3LabelSN,
		@rACS1LabelBASE as ACS1LabelBASE,@rACS2LabelBASE as ACS2LabelBASE,@rACS3LabelBASE as ACS3LabelBASE,
		@rACS1LabelBOX as ACS1LabelBOX,@rACS2LabelBOX as ACS2LabelBOX,@rACS3LabelBOX as ACS3LabelBOX,
		@rACS1LabelPAT as ACS1LabelPAT,@rACS2LabelPAT as ACS2LabelPAT,@rACS3LabelPAT as ACS3LabelPAT

	return
GO