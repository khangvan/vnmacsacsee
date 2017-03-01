SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE  PROCEDURE [dbo].[ame_check_dataFFC]
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

	declare @rTopModel char(30)
	declare @rTopModelLimits char(30)
	declare	@rModel1 char(30) 
	declare	@rModel2 char(30) 
	declare	@rLabelSN char(30)
	declare	@rLabelBASE char(30)
	declare	@rLabelBOX char(30) 
	declare	@rLabelPAT char(30) 
	
	declare @sname char(20)
	declare @scount int

	set @rTopModel ='NG'
	set @rTopModelLimits ='NG'
	set @rModel1 ='NG'
	set @rModel2 ='NG'
	set @rLabelSN ='NG'
	set @rLabelBASE ='NG'
	set @rLabelBOX ='NG'
	set @rLabelPAT ='NG' 

	if exists (select tffc_kicker_model from tffc_kicker_table where tffc_kicker_model=@TopModel)
	begin
		set @rTopModel='OK'
	end

	if exists (select sap_model_name from subtestlimits where sap_model_name=@TopModel and station_name=@TestStation)
	begin
		set @rTopModelLimits='OK'
	end
	
	if exists (select tffc_kicksub_model from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model1)
	begin
		set @rModel1='OK'
	end
	
	if exists (select tffc_kicksub_model from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model2)
	begin
		set @rModel2='OK'
	end
	
	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelSN)
	begin
		set @rLabelSN='OK'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelBASE)
	begin
		set @rLabelBASE='OK'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelBOX)
	begin
		set @rLabelBOX='OK'
	end

	if exists (select prf_bompartname from nacs_printfilelookup where prf_bompartname=@LabelPAT)
	begin
		set @rLabelPAT='OK'
	end
	

	select @rTopModel as TopModel, @rTopModelLimits as TopModelLimits, @rModel1 as Model1,
		@rModel2  as Model2, @rLabelSN as LabelSN, @rLabelBASE as LabelBASE,
		@rLabelBOX as LabelBOX, @rLabelPAT as LabelPAT

	if (@rTopModel='OK')
	begin
		select * from tffc_kicker_table where tffc_kicker_model=@TopModel
	end
	if (@rTopModelLimits='OK')
	begin
		select * from subtestlimits where sap_model_name=@TopModel and station_name=@TestStation
	end
	if (@rModel1='OK')
	begin
		select * from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model1

		set @sname='ACSVNDALIFFCST'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model1
		order by Partlist.Disp_Order

		set @sname='ACSVNONESTART'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model1
		order by Partlist.Disp_Order
	end
	if (@rModel2='OK')
	begin
		select * from tffc_kicksub where tffc_kicksub_model=@TopModel and tffc_kicksub_part=@Model2
		
		set @sname='ACSVNDALIFFCST'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model2
		order by Partlist.Disp_Order

		set @sname='ACSVNONESTART'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@Model2
		order by Partlist.Disp_Order
	end
	if (@rLabelSN='OK')
	begin
		select * from nacs_printfilelookup where prf_bompartname=@LabelSN

		set @sname='ACSVNFFCDALILBL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN
		order by Partlist.Disp_Order

		set @sname='ACSVNONELABEL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN
		order by Partlist.Disp_Order

		set @sname='ACSVNTWOLABEL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelSN
		order by Partlist.Disp_Order
	end
	if (@rLabelBASE='OK')
	begin
		select * from nacs_printfilelookup where prf_bompartname=@LabelBASE

		set @sname='ACSVNFFCDALILBL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE
		order by Partlist.Disp_Order

		set @sname='ACSVNONELABEL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE
		order by Partlist.Disp_Order

		set @sname='ACSVNTWOLABEL'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBASE
		order by Partlist.Disp_Order
	end
	if (@rLabelBOX='OK')
	begin
		select * from nacs_printfilelookup where prf_bompartname=@LabelBOX

		set @sname='ACSVNFFCDALIBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX
		order by Partlist.Disp_Order

		set @sname='ACSVNONEBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX
		order by Partlist.Disp_Order

		set @sname='ACSVNTWOBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelBOX
		order by Partlist.Disp_Order
	end
	if (@rLabelPAT='OK')
	begin
		select * from nacs_printfilelookup where prf_bompartname=@LabelPAT

		set @sname='ACSVNFFCDALIBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT
		order by Partlist.Disp_Order

		set @sname='ACSVNONEBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT
		order by Partlist.Disp_Order

		set @sname='ACSVNTWOBOX'
		select @scount=Station_Count from Stations where Station_Name=@sname and Status='A'
		select Part_No_Name, Description, Partlist.Menu, Partlist.Automatic, Partlist.Get_Serial, Partlist.Disp_Order,
		Partlist.Fill_Quantity from Catalog Inner join Partlist
		on Catalog.Part_No_Count=Partlist.Part_No
		where Partlist.Station=@scount and Part_No_Name=@LabelPAT
		order by Partlist.Disp_Order
	end
	return
GO