SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ModifyUpdate_PartControl]
@partname char(20),
@station char(20),
@menu char(1),
@automatic char(1),
@getserial char(5),
@disporder int,
@fillquantity int,
@iclearcontrol int
 AS

set nocount on


declare @scount int
declare @pcount int
declare @plid int
declare @readdisporder int


	--Verify that non-NULLable parameter(s) have values
	if @station is NULL
	   begin
		raiserror ('E116.1 Illegal Parameter Value. You must specify a station name.',
			16,1) with nowait
		return
	   end
	if @partname is NULL
	   begin
		raiserror ('E116.2 Illegal Parameter Value. You must specify a part name.',
			16,1) with nowait
		return
	   end
	--See if Station exists
	if not exists(select Status from Stations 
		where Station_Name=@station)
	   begin
		raiserror ('E116.3 Illegal Parameter Value. Station %s does not exist.',
			16,1,@station) with nowait
		return
	   end
	select @scount = Station_Count from Stations
		where Station_Name=@station
	--See if Part exists
	if not exists(select Status from Catalog 
		where Part_No_Name=@partname)
	   begin
		raiserror ('E116.4 Illegal Parameter Value. Part %s does not exist.',
			16,1,@partname) with nowait
		return
	   end
	select @pcount = Part_No_Count from Catalog
		where Part_No_Name=@partname

           if @iclearcontrol = 1 
           begin
                delete from partlist where station = @scount and part_no = @pcount
           end
           else
           begin
                 select @plid = pl_id, @readdisporder = Disp_Order  from partlist where station = @scount and part_no = @pcount
                 if @plid is not null
                 begin
                   select @readdisporder = Disp_Order  from partlist where pl_id = @plid
                   exec ame_modify_part_control @partname, @station, @menu, @automatic, @getserial, @readdisporder

                 end
                 else   -- new control
                 begin
                       exec ame_create_part_control @partname, @station, @menu, @automatic, @getserial

                 end

           end
     select 'OK'
GO