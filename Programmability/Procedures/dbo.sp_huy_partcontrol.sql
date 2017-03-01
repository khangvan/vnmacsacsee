SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_huy_partcontrol]
	@PartNoName nvarchar(30),
	@Station nvarchar(30),
	@Auto char(1)

AS
	set nocount on

	declare @count int

	exec ame_create_part @PartNoName
	if not exists 
	(
	select partlist.Part_No from partlist
		inner join stations on partlist.station=stations.station_count
		inner join catalog on partlist.Part_No=Catalog.Part_No_Count
		where stations.station_name=@Station
		and Catalog.Part_No_Name=@PartNoName
	) 
	begin
		select top 1 @count = Disp_Order from partlist
			inner join stations on partlist.station=stations.station_count
			where stations.station_name=@Station
			order by partlist.disp_order desc
		set @count = @count + 1
		exec ame_create_part_control @PartNoName, @Station, '', @Auto, 'N', @count, 1
	end

	select partlist.Part_No,catalog.part_no_name, partlist.Station,stations.station_name,partlist.Automatic from partlist
		inner join stations on partlist.station=stations.station_count
		inner join catalog on partlist.Part_No=Catalog.Part_No_Count
		where stations.station_name=@Station
		and Catalog.Part_No_Name=@PartNoName
GO