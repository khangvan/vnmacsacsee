SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO






-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_BCS_SaveModelTestStepswORT](
	-- Add the parameters for the stored procedure here
	@model char(30), 
	@test char(30),
	@TestInfo dbo.TestRecords READONLY,
	@ModelInfo dbo.modelRecords READONLY,
		@Steps dbo.StepRecord READONLY,
	@Limits dbo.SubtestLimitsRecordswORT READONLY,
	@Params dbo.StepParametersRecords READONLY,
	@buttons dbo.Buttons READONLY
	)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @stepname char(30)
	declare @steptype char(30)
	declare @testname char(30)
	declare @testid int
	declare @modelname char(30)
	declare @modelid int
	declare @amodel char(30)
	declare @order int
	declare @stepParent char(50)
	declare @StepDescription char(100)
	declare @stepID int

	declare mycursor CURSOR FOR select * from @Steps



	print @stepname
	print @order


	Merge
    BCS_Test  as T
	Using @TestInfo AS S
	on T.TEST_Name = S.Test_Name
	when matched then update set T.TEST_Description = S.TEST_Description, T.TEST_Path = S.TEST_Path,
	T.TEST_DLLName = S.TEST_DLLName, T.TEST_NameSpace = S.TEST_NameSpace, T.TEST_TargetUI = S.TEST_TargetUI,
	T.TEST_TargetTestName = S.TEST_TargetTestName, T.TEST_FullNameSpace = S.TEST_FullNameSpace,
	T.TEST_TestStationSteps = S.TEST_TestStationSteps 
	when  not matched by Target then
	insert (TEST_Name,TEST_Description,TEST_Path, TEST_DLLName,
	TEST_NameSpace, TEST_TargetUI, TEST_TargetTestName, TEST_FullNameSpace, TEST_TestStationSteps) 
	values (S.TEST_Name,S.TEST_Description, S.Test_Path,	S.TEST_DLLName,
	 S.TEST_NameSpace, S.TEST_TargetUI, S.TEST_TargetTestName,S.TEST_FullNameSpace,S.TEST_TestStationSteps) ;


	 Merge
	 BCS_Models as T
	 using @ModelInfo as S
	 on T.MODEL_Name = S.MODEL_Name
	 when matched
	 then update set T.MODEL_Description = S.MODEL_Description
	 when not matched by target
	 then insert (MODEL_Name, MODEL_Description) values
	 (S.MODEL_Name, S.MODEL_Description ) ;

--	insert into BCS_Steps (STEP_Name,STEP_Type,STEP_TEST_ID,STEP_MODEL_ID, STEP_Order)
--	select STEP_Name, STEP_Type,STEP_Test_ID,3,STEP_ORDER from @Steps

	select top 1 @testname = TEST_Name from @TestInfo
    select @testid = TEST_ID from BCS_Test where TEST_Name =@testname

	select top 1 @modelname = MODEL_Name from BCS_Models where Model_Name= @model
	select @modelid = MODEL_ID from BCS_Models where Model_Name = @modelname

	declare @stepdelid int
    declare  stepcur  cursor for select STEP_ID from BCS_Steps where STEP_TEST_ID = @testid and STEP_Model_ID = @modelid
    open stepcur
	FETCH NEXT from stepcur into @stepdelid 

	while @@FETCH_STATUS = 0
	begin
	    delete from BCS_StepParameters where NACS_Step_ID = @stepdelid
		delete from BCS_SubTestLimits where STEP_ID = @stepdelid
		delete from BCS_Buttons where BCS_Step_ID = @stepdelid
		FETCH NEXT from stepcur into @stepdelid 
	end
	close stepcur
	deallocate stepcur


	delete from BCS_Steps where STEP_TEST_ID = @testid and STEP_Model_ID = @modelid

	
	
	open mycursor
	FETCH NEXT from mycursor into @stepID,@stepname, @steptype, @testname,  @amodel, @order, @stepParent, @StepDescription


	while @@FETCH_STATUS = 0
	begin


		insert into BCS_Steps (STEP_Name,STEP_Type, STEP_TEST_ID,STEP_MODEL_ID,STEP_Parent_id,STEP_Order, STEP_Description)
		values (@stepname, @steptype,@testid,@modelid,0,@order,@StepDescription )

		declare @id int

		set @id = SCOPE_IDENTITY()


		insert into BCS_StepParameters (NACS_Step_ID,NACS_StepParameter_Type,NACS_StepParameter_Name,
		NACS_StepParameter_strValue,NACS_StepParameter_intValue, NACS_StepParameter_floatValue,
		NACS_StepParameter_Description,NACS_StepParameter_Object)
		select @id, StepParameter_Type, StepParameter_Name,
		StepParameter_strValue, StepParameter_intValue, StepParameter_floatValue,
		StepParameter_Description, StepParameter_Object from @Params where  StepParameter_StepID = @stepid
		

		insert into BCS_SubTestLimits (STEP_ID, Station_Name, SubTest_Name, SAP_Model_Name, 
		SAP_MODEL_ID, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, 
		ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, OpportunitiesforFail,flgForFailure,flgFirstOnly,DoAlways,SkipInORT )
		select @id, station_name, subtest_name,SAP_Model,
		@modelid,Limit_Type, UL,LL,strLimit,flgLimit,Units,Description, Author,
		ACSEEMode,SPCParm,Hard_UL,Hard_LL,GETDATE(),0,0,flgForFailure,flgForFirst,flgDoAlways,flgDoInORT
		from @Limits where  STEP_ID = @stepID
		
		if exists ( select BUTTON_STEP_ID from @buttons where BUTTON_STEP_ID = @stepID )
		begin
		   insert into BCS_Buttons (BCS_Button_Name,BCS_Button_Type,
		   BCS_Step_ID)
		   select  BUTTON_NAME, BUTTON_TYPE, @id from @buttons where BUTTON_STEP_ID = @stepID
		end


	FETCH NEXT from mycursor into @stepID,@stepname, @steptype, @testname,  @amodel, @order, @stepParent, @StepDescription

	--	FETCH NEXT from mycursor into @stepID,@stepname, @steptype, @testname, @amodel, @order, @stepParent
	--	MERGE
	--	BCS_StepParameters as T
	--	using (select STEPParameters_Name, 


	--     declare curLimits CURSOR for select * from @Limits where STEP_Name = @stepname



	--	 declare curParams CURSOR for select * from @Params where StepParameter_STEPName =@stepname



			print @stepname
	print @order
	end
	
	close mycursor
	deallocate mycursor

	
	declare fixup CURSOR FOR select STEP_Name, STEP_Parent from @Steps

	open fixup

	declare @parentName varchar(50)
	declare @parentid int
	
	FETCH NEXT from fixup into @stepname, @parentName
	while @@FETCH_STATUS = 0
	begin

	     if (@parentName is not null )
		 begin
		    if ( len(rtrim(@parentname)) > 0 )
			begin
		    select @parentid = STEP_ID from BCS_Steps where STEP_Name = @parentname and STEP_TEST_ID = @testid and STEP_MODEL_ID = @modelid
	        update BCS_Steps set  STEP_Parent_id = @parentid where STEP_Name = @stepname and STEP_TEST_ID = @testid and STEP_MODEL_ID = @modelid
            end
			else
			begin
			print 'STEP_ID'
			update BCS_Steps set  STEP_Parent_id = 0 where STEP_Name = @stepname and STEP_TEST_ID = @testid and STEP_MODEL_ID = @modelid
			end
		 end
		 else
		 begin
		  update BCS_Steps set  STEP_Parent_id = 0 where STEP_Name = @stepname and STEP_TEST_ID = @testid and STEP_MODEL_ID = @modelid
print 'second'
		 end
		 FETCH NEXT from fixup into @stepname, @parentName
	end
	 
	close fixup
	deallocate fixup
	
    -- Insert statements for procedure here

END






GO