SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FillWeekCtr]
 AS

declare @year int
declare @week int
declare @ctr int


set @year = 2007

while @year < 2100
begin
set @week = 0
while @week < 54
begin

   insert into WeekCTR
    (
       WeekCtr_Year,
        WeekCtr_Week,
        WeekCtr_Counter
    )
    values
    (
         @year,
          @week,
           0
    )
set @week = @week + 1

end


set @year = @year + 1

end
GO