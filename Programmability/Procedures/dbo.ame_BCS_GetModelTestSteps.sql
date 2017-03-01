SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:  <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_BCS_GetModelTestSteps] 
-- Add the parameters for the stored procedure here
@model char ( 30 ) , 
@test char ( 30 ) 
AS 
BEGIN 
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON; 
    DECLARE @testid AS int 
    DECLARE @modelid AS int 

    SELECT @testid = TEST_ID FROM BCS_Test WHERE TEST_Name = @test 

    SELECT @modelid = MODEL_ID FROM BCS_Models WHERE MODEL_Name = @model 

    -- Insert statements for procedure here

    SELECT 'MODEL' 

    SELECT 
    MODEL_ID , 
    MODEL_NAME , 
    MODEL_DESCRIPTION 
    FROM BCS_Models WHERE MODEL_ID = @modelid 

    SELECT 'TESTS' 

    SELECT 
    TEST_ID , 
    TEST_Name , 
    TEST_Description , 
    TEST_Path , 
    TEST_DLLName , 
    TEST_NameSpace , 
    TEST_TargetUI , 
    TEST_TargetTestName , 
    TEST_FullNameSpace , 
    TEST_TestStationSteps 
    FROM BCS_Test WHERE TEST_ID = @testid 

    SELECT 'STEPS' 

    SELECT 
    STEP_ID , 
    STEP_Name , 
    STEP_Type , 
    STEP_TEST_ID , 
    STEP_MODEL_ID , 
    STEP_Parent_id , 
    STEP_Order , 
    STEP_Description 
    FROM BCS_STEPS 
    WHERE STEP_TEST_ID = @testid 
    AND STEP_MODEL_ID = @modelid 

    SELECT 'LIMITS' 

    SELECT 
    STEP_ID , 
    Station_Name , 
    SubTest_Name , 
    SAP_Model_Name , 
    SAP_MODEL_ID , 
    Limit_Type , 
    UL , 
    LL , 
    strLimit , 
    flgLimit , 
    Units , 
    Description , 
    Author , 
    ACSEEMode , 
    SPCParm , 
    Hard_UL , 
    Hard_LL , 
    Limit_Date , 
    ProductGroup_Mask , 
    Limit_ID , 
    Note_ID , 
    OpportunitiesforFail , 
    flgForFailure , 
    flgFirstOnly , 
    DoAlways , 
    SkipInOrt 
    FROM BCS_SubTestLimits WHERE STEP_ID IN 
    ( 
        SELECT STEP_ID FROM BCS_Steps 
        WHERE STEP_TEST_ID = @testid 
        AND STEP_MODEL_ID = @modelid 
    ) 

    SELECT 'PARAMETERS' 

    SELECT 
    NACS_StepParameters_id , 
    NACS_Step_ID , 
    NACS_StepParameter_Type , 
    NACS_StepParameter_Name , 
    NACS_StepParameter_strValue , 
    NACS_StepParameter_intValue , 
    NACS_StepParameter_floatValue , 
    NACS_StepParameter_Description , 
    NACS_StepParameter_Object 
    FROM BCS_StepParameters WHERE NACS_STEP_ID IN 
    ( 
        SELECT STEP_ID FROM BCS_Steps 
        WHERE STEP_TEST_ID = @testid 
        AND STEP_MODEL_ID = @modelid 
    ) 

    SELECT 'BUTTONS' 

    SELECT 
    BCS_Button_ID , 
    BCS_Button_Name , 
    BCS_Button_Type , 
    BCS_Step_ID , 
    BCS_Relationship , 
    BCS_Notes 
    FROM BCS_Buttons WHERE BCS_STEP_ID IN 
    ( 
        SELECT STEP_ID FROM BCS_Steps 
        WHERE STEP_TEST_ID = @testid 
        AND STEP_MODEL_ID = @modelid 
    ) 

END 


GO