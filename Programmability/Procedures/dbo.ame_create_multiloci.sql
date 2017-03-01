SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO

create proc [dbo].[ame_create_multiloci]

 @startSN char(20),

 @endSN char(20),

 @nextStation char(20),

 @sapModel char(20)

 

AS

set nocount on

 

declare @pref1 char(20)

declare @pref2 char(20)

declare @startCounter int

declare @endCounter int

declare @countLen1 int

declare @countLen2 int

declare @tempCount char(17)

declare @tempSN char(20)

declare @tempLen int

declare @temppref char(20)

 

set @pref1 = substring(@startSN,1,3)

set @pref2 = substring(@endSN,1,3)

if ltrim(@pref1)<>ltrim(@pref2)

   begin

            select 'Error: Serial number prefixes do not match'

            return

   end

 

set @countLen1 = len(@startSN)-3

set @countLen2 = len(@endSN)-3

if @countLen1<>@countLen2

   begin

            select 'Error: Length of serial numbers must be the same'

            return

   end

 

-- Now we can just use @pref1 and @countLen1

set @startCounter = convert(int,substring(@startSN,4,@countLen1))

set @endCounter = convert(int,substring(@endSN,4,@countLen1))

 

if @startCounter>=@endCounter

   begin

            select 'Error: StartSN must be less than EndSN'

            return

   end

 

while @startCounter<=@endCounter

   begin

            set @tempCount = convert(char(17),@startCounter)

            set @tempLen=@countLen1

            set @tempLen = @countLen1-len(@tempCount)

            set @temppref = @pref1

            while @tempLen>0

               begin

                        set @temppref = rtrim(@temppref)+'0'

                        set @tempLen = @tempLen - 1

               end

            set @tempSN = rtrim(@temppref)+convert(char(17),@startCounter)

            --select @tempSN

            exec ame_create_loci @tempSN,@sapModel,0,0,0,0,@nextStation,'ame_create_multiLoci','Insert'

            set @startCounter = @startCounter + 1

   end

--select * from loci where test_id='ame_create_multiLoci'
GO