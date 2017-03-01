SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getNewUpStreamStation] 
@sname char(20)
AS
declare @scount int

	select @scount=Station_Count from Stations
		where Station_Name=@sname and Status='A'
	if @@ERROR <>0
	   begin
		raiserror('E8.3 Undefined error. Unable to retrieve Station db data.',17,1)
		return
	   end
	-- Create output cursor
	select Station_Name, Machine_Name from Stations Inner join Lines
		on Stations.Station_Count=Lines.Station
		where Lines.Next_Station=@scount
GO