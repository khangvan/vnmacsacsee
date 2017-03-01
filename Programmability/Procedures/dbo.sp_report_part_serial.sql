SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_report_part_serial]
	@pname char(20)=NULL, -- Part_No_Name
	@pserial char(20)=NULL -- Scanned_Serial
-- Define code

AS

	--define local variables
	declare @pcount int -- Added_Part_No
	set @pcount = NULL

	--Verify that non-NULLable parameter(s) have values
	if @pname is NULL
	   begin
		raiserror ('E503.1 Illegal Parameter Value. You must specify a Part Name.',
			16,1) with nowait
		return
	   end

	if @pserial is NULL
	   begin
		raiserror ('E503.2 Illegal Parameter Value. You must specify a Part Serial Number.',
			16,1) with nowait
		return
	   end

	--See if part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@pname)
	   begin
		raiserror ('E503.3 Illegal Parameter Value. Part %s does not exist.',
			16,1,@pname) with nowait
		return
	   end

	select @pcount=Part_No_Count from Catalog
		where Part_No_Name=@pname
	if @@ERROR <>0
	   begin
		raiserror('E503.4 Undefined error. Unable to retrieve Catalog data.',17,1)
		return
	   end

	--See if assembly exists
	if not exists(select Station from asylog 
		where Scanned_Serial=@pserial and Added_Part_No=@pcount)
	   begin
		raiserror ('E503.4 Illegal Parameter Value. This Part with this SN does not exist.',
			16,1) with nowait
		return
	   end
	-- Create output cursor
	select ACS_Serial,Stations.Station_Name, Actions.Description, Rev, Action_Date,
		Quantity from asylog Inner join Stations
		on asylog.Station=Stations.Station_Count Inner join Actions
		on asylog.Action=Actions.Action_Count
		where asylog.Scanned_Serial=@pserial and asylog.Added_Part_No=@pcount
-- Create the Stored Procedure


GO