SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getNewDownStreamStation]
@sname char(20)
 AS
declare @scount int

             select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E9.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- Create output cursor
	select Station_Name, Machine_Name from Stations Inner join Lines
		on Stations.Station_Count=Lines.Next_Station
		where Lines.Station=@scount
			
GO