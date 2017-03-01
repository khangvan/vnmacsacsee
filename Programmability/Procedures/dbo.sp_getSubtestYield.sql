SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

--drop proc dbo.sp_getSubtestYield

CREATE proc [dbo].[sp_getSubtestYield]
	@Prod char(10),
	@ProdLine char(10),
	@Station varchar(30),
	@TestDate datetime
As

declare @SubTest_Name char(30)
declare @Pass_Fail char(2)
declare @SAP_Model char(20)
declare @Test_Date_Time datetime
declare @Total int
declare @Failed int
declare @CurrentSubTest char(30)
declare @Prefix char(2)

Set @Total = 1
set @Failed = 0
set @Prefix='X'

if @Prod='Viper' and @ProdLine='ViperLine'
	begin
	   set @Prefix='SE'
	end

if @Prod='Python' and @ProdLine='ViperLine'
	begin
	   set @Prefix='SG'
	end

set nocount on
if @Prefix = 'X'
   begin
	DECLARE Subtest SCROLL CURSOR FOR
	select subtestlog.SubTest_Name, subtestlog.Pass_Fail,testlog.SAP_Model,testlog.Test_Date_Time from subtestlog
		inner join testlog
		on testlog.Test_ID=subtestlog.Test_ID
		where testlog.ACSEEMode=0 And subtestlog.Station= @Station and datediff(day,testlog.Test_Date_Time,@TestDate)=0
		order by SubTest_Name
   end
else
   begin
	DECLARE Subtest SCROLL CURSOR FOR
	select subtestlog.SubTest_Name, subtestlog.Pass_Fail,testlog.SAP_Model,testlog.Test_Date_Time from subtestlog
		inner join testlog
		on testlog.Test_ID=subtestlog.Test_ID
		where testlog.ACSEEMode=0 And subtestlog.Station= @Station and datediff(day,testlog.Test_Date_Time,@TestDate)=0
		and substring(subtestlog.ACS_Serial,1,2)=@Prefix
		order by SubTest_Name
   end


create table #tmpSubTests (
	Date_Tested datetime NOT NULL,
	Test_Station char(30) NULL,
	Product_Line char(10) NULL,
	SubTest_Name char(30) NOT NULL,
	Qty_Tested int NULL,
	Qty_Fail int NULL,
	Product char(10) NULL,
	FirstRun char(2) NULL
)
	
OPEN Subtest

FETCH NEXT FROM Subtest
into @SubTest_Name,@Pass_Fail,@SAP_Model,@Test_Date_Time
set @CurrentSubTest=@SubTest_Name
if ltrim(@Pass_Fail)='F'
   begin
	set @Failed = 1
   end

WHILE @@FETCH_STATUS = 0
  BEGIN
    FETCH NEXT FROM Subtest
	into @SubTest_Name,@Pass_Fail,@SAP_Model,@Test_Date_Time
	if ltrim(@SubTest_Name)=ltrim(@CurrentSubTest) 
	  begin
		set @Total = @Total +1
		if ltrim(@Pass_Fail)='F'
   		   begin
			set @Failed = @Failed + 1
   		   end
	  end
	else
	  begin
		insert #tmpSubTests
		values(@TestDate,@Station,@ProdLine,@CurrentSubTest,@Total,@Failed,@Prod,'T')

		set @CurrentSubTest=@SubTest_Name
		set @Total = 1
		set @Failed = 0
		if ltrim(@Pass_Fail)='F'
   		   begin
			set @Failed = 1
   		   end
	  end
  END

  

CLOSE Subtest
DEALLOCATE Subtest

select * from #tmpSubTests
drop table #tmpSubTests

--set nocount off
--select * from testlog where Station = 'ViperPerformance1' and
--	 datediff(day,test_date_time,convert(datetime,'5/10/2002',101)) =0 and Pass_Fail='F'
GO