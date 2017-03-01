SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TMRawTRPInsert]
@SerialCode char(20), 
@Model char(20), 
@Station char(20), 
@Date datetime, 
@Time datetime, 
@Details char(80), 
@Performed char(80),
@Esito char(80), 
@ValueAcquired char(80), 
@Extra1 char(80),
@intvalue int = null,
@floatvalue real = null,
@units char(30) = '',
@comment char(80) = ''
 AS
set nocount on


declare @timeofrecordbeingadded datetime

declare @lastmaxdatetimeforstation  datetime

set @timeofrecordbeingadded =
dateadd(ss,datepart(ss,@time),
dateadd(mi,datepart(mi,@time),
DateAdd(hh,datepart(hh,@time),@date)))


if exists (select    TM_LastDateTime from tm_lastloadtimesperstation
where TM_Station = rtrim(@station) + 'i1')
begin
select   @lastmaxdatetimeforstation = TM_LastDateTime from tm_lastloadtimesperstation
where TM_Station = rtrim(@station) + 'i1'
end
else
begin
set @lastmaxdatetimeforstation = '1/1/2009'
end

if  @timeofrecordbeingadded > @lastmaxdatetimeforstation
begin
insert into TM_RawTRPData
(
TRP_SerialCode, 
TRP_Model, 
TRP_Station, 
TRP_Date, 
TRP_Time, 
TRP_Details, 
TRP_Performaed, 
TRP_Esito, 
TRP_ValueAcquired, 
TRP_Extra1,
TRP_intValue,
TRP_floatValue,
TRP_Units,
TRP_Comment
)
values
(
@SerialCode, 
@Model , 
@Station , 
@Date, 
@Time , 
@Details , 
@Performed,
@Esito , 
@ValueAcquired , 
@Extra1,
@intValue,
@floatValue,
@units,
@comment
)

select 'OK'
end
else
begin
select 'NO'
end
GO