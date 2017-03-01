SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getNextWeekCounter]
@year int,
@week int,
@ctr int output
 AS
set nocount on

update WeekCtr set WeekCtr_Counter = WeekCtr_Counter + 1 from  WeekCtr where WeekCtr_year = @year and WeekCtr_week = @week
select @ctr =  WeekCtr_Counter  from WeekCtr where WeekCtr_year = @year and WeekCtr_week = @week
select WeekCtr_Counter  from WeekCtr where WeekCtr_year = @year and WeekCtr_week = @week
GO