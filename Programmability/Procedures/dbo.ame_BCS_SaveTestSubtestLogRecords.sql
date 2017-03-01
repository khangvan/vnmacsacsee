SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_BCS_SaveTestSubtestLogRecords] 
	@aTestlog dbo.testLogRecord READONLY,
	@aSubtestLogs dbo.subtestLogRecord READONLY
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	insert into BCS_testlog
	(
		ACS_Serial, SAP_Model, TestName,WorkCenter, Station,
		Test_ID,  Pass_Fail, FirstRun, ACSEEMode, UsageMode, Test_Date_Time
	)
	select unitSerial, model,testName,WorkCenter,Station,
	test_ID, Pass_Fail,FirstRun, ACSEEMode,UsageMode, testDateTime  from @aTestlog


	declare @id int
	select @id = @@IDENTITY

	insert into BCS_subtestlog
	(
		ACS_Serial, Station, SubTest_Name, Limit_Name, Test_ID, Pass_Fail, strValue, 
		intValue, floatValue, Units, Comment,  STL_TL_ID
	)
	select unitSerial, station_name,step_name,limit_name, test_ID,Pass_Fail,strValue,
	intValue, floatValue, Units,Comment,@id from @aSubtestLogs

	select @id as TLID

	select ACS_Serial as ACS_Serial,Station as Station, subtest_name as subtest_name,
	Limit_Name as Limit_Name, Test_ID as Test_ID, Pass_Fail as Pass_Fail,
	strValue as strValue, intValue as intValue, floatValue as floatValue,
	Units as Units,Comment as Comment, STL_TL_ID as STL_TL_ID, STL_ID as STL_ID
	 from BCS_subtestlog where STL_TL_ID =@id

END



GO