SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_HBICModulo]
@instring char(50),
@outstring char OUT
AS
set nocount on


declare @length int
declare @current int
declare @currentvalue int
declare @sum int
declare @remainder int
declare @currentchar char

set @length = len(@instring)
set @sum = 0 

set @current = 0 
while @current < @length
begin
  set @currentchar = substring(@instring,@current+1,1 )
  set @currentchar = UPPER(@currentchar)
print @currentchar


   select @currentvalue = HBICID from HBICLICDataFormatCharacters where character = @currentchar

print @currentvalue

print '-----------------------'
   set @sum = @sum + @currentvalue
   
   set @current = @current + 1
end


select @sum

select @remainder = @sum % 43

print 'REMAINDER'
print @remainder

select @outstring = character from HBICLICDataFormatCharacters where HBICID = @remainder

select @outstring
GO