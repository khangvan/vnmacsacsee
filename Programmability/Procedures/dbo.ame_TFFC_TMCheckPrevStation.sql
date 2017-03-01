SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_TMCheckPrevStation]
@model char(20),
@serial char(20),
@station char(20),
@OK char(20) OUTPUT,
@rework char(20) OUTPUT
AS

set nocount on

declare @nextstation char(20) ;

declare @nexttest char(20)
declare @stationtest char(20)

declare @nextstationlength int
declare @stationlength int

declare @lookupnextstation char(20)
declare @lookupnextstationlength char(20)
declare @lookupstation char(20)
declare @lookupstationlength int
declare @nextstationproductgroup_mask int
declare @stationproductgroup_mask int

declare @nextstationordervalue int
declare @stationordervalue int

select @nextstation = next_station_name 
from [ACSEEState].[dbo].loci 
where acs_serial = rtrim(@serial)

if rtrim(@nextstation) = 'TMTEST'
	begin
		   set @OK = 'OK'
		   set @rework='NONE'
	end
else
	begin    
		if @nextstation is not null
			begin
				-- look to see if previous station
				select @lookupnextstation = station_name, @nextstationordervalue =Order_Value 
				from [ACSEEClientState].[dbo].Stations 
				where station_name = rtrim(@nextstation)

				print 'next station'
				print @nextstationordervalue
				
				if @nextstationordervalue > 100
					begin
						set @OK = 'OK'
						set @rework='REWORK'
					end
				else
					begin
						set @OK=@nextstation
						set @rework = 'NONE'        
					end
			end
		else -- next station is null
			begin
				set @OK = 'SERIAL NOT FOUND'
				set @rework = 'NONE'
			end
	end
	
select @OK as OK, @rework as rework
GO