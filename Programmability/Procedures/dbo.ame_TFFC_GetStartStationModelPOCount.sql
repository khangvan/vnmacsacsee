SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetStartStationModelPOCount]
@station char(20) = '',
@PO char(20),
@Model char(20),
@increment int,
@Count int OUTPUT
 AS
set nocount on


declare @currentCount int
declare @nextCount int
declare @id int

begin transaction 

select @id = POMODELCOUNT_ID, @currentCount = POMODELCOUNT_Count from POMODELCOUNT WITH (HOLDLOCK XLOCK ROWLOCK) where POMODELCOUNT_PO = @PO and POMODELCOUNT_Model = @Model  and POMODELCOUNT_Station = @station

if @id is null
begin
insert into POMODELCOUNT
(
POMODELCOUNT_Station,
POMODELCOUNT_PO,
POMODELCOUNT_Model,
POMODELCOUNT_Count,
POMODELCOUNT_firstdate
)
values
(
@station,
@PO,
@Model,
@increment,
getdate()

)
set @nextCount = 0
end
else
begin
   set @nextCount = @currentCount + @increment 
   update POMODELCOUNT set POMODELCOUNT_Count = @nextCount , POMODELCOUNT_LastDate=getdate()  where POMODELCOUNT_ID = @id
end

set @Count = @nextCount
select @nextCount

commit transaction
GO