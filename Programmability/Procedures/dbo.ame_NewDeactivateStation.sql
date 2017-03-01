SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NewDeactivateStation]
@sname char(20),
@Result int OUTPUT
 AS
declare @scount int


set @Result = 0
if  exists(select Status from Stations 
	where Station_Name=@sname)
begin
	-- Obtain Station_Count value for testing
	select @scount=Station_Count from Stations 
		where Station_Name=@sname



	if not exists(select Station from Lines
		where Station=@scount or Next_Station=@scount)
             begin
                 update stations
                 set Status='D'
                 where station_name = @sname
              end
              else
              begin
                set @Result = 2
              end
end
else
begin
   set @Result = 1
end
GO