SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ACSPARTS_FINDSTR]
@findstr char(20),
@targetstr char(50),
@foundpos int OUTPUT
 AS
set nocount on


declare @findstrlen int
declare @findstrpos int
declare @examinestr char(20)
declare @found int
declare @searchstr char(20)

--print 'looking for+++++++++++++++++++++++'
--print '[' + @findstr +']'
--print 'in ----------------------------------'
--print @targetstr


set @searchstr = rtrim(@findstr)
set @found = 0
set @findstrlen = len(@searchstr)
set @findstrpos = 1

while ( @findstrpos + @findstrlen) <= (len(@targetstr) +1 ) 
begin
   set @examinestr = substring(@targetstr,@findstrpos, @findstrlen)

   if @examinestr = @searchstr
   begin
      set @found = @findstrpos
   end     
   set @findstrpos = @findstrpos + 1
end

--print @found

set @foundpos =  @found
GO