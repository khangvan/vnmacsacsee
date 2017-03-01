SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


create proc [dbo].[sp_get_best_limit]
-- Define input parameters
	@Station	char(20),
	@SAPModel	char(20)
-- Define Code
AS
	-- Initialize variables
set nocount on
declare @BestModel char(20)
declare @BestRating int
declare @SAP char(20)
declare @rating int
declare @i int

set @BestModel='Not Found'
set @BestRating = 100
if @Station is null
   begin
      --error out
      return
   end
if @SAPModel is null
   begin
      --error out
      return
   end
	
declare Limits_at_Station cursor forward_only
for
select SAP_Model_Name from subtestlimits where station_name=ltrim(@Station)
for read only

open Limits_at_Station
fetch Limits_at_Station into @SAP
while @@fetch_status = 0
   begin
	-- Now calculate the rating
	set @rating = 100
	if ltrim(@SAP) = ltrim(@SAPModel)
	   begin
		set @rating = 0
	   end
	else
	   begin
	      if len(@SAP) = len(@SAPModel)
		begin
		   set @rating = 0
		   set @i = 1
		   while @i <= len(@SAPModel)+1
			begin
			   if substring(@SAP,@i,1) ='?'
			      begin
				-- deal with the wild card
				set @rating = @rating +1
			      end
		   	   else
			      begin
				-- see if we're still on track
				if substring(@SAP,@i,1)<>substring(@SAPModel,@i,1)
				   begin
					set @rating = 100 --this isn't the correct model
					set @i = 100 -- break out of loop
				   end
			      end
			   set @i = @i +1
			end
		end
	   end
	--select @SAP,@rating   
	if (@rating<21) and (@rating<@BestRating)
	   begin
		set @BestModel = @SAP
		set @BestRating = @rating
	   end                                                                                                                                                                      
	FETCH NEXT FROM Limits_at_Station into @SAP
   end
--select @BestModel,@BestRating
close Limits_at_Station
deallocate Limits_at_Station

if @BestModel <> 'Not Found'
   begin
	select * from subtestlimits
		where Station_Name = @Station and SAP_Model_Name = @BestModel
   end


GO