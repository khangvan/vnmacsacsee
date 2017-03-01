SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_Stage_GetComparedLimits]
@username char(50)
AS
set nocount on

select 
Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail, Staging_Type as OldNew
 from  Stage_Subtestlimits where TableUser = @username
order by  stage_id
GO