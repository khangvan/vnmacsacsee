SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getLimitModel_Notes] 
@station char(20),
@model char(20)
AS
set nocount on

select Station_Name,SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, Retire_Date, 
MLH_ID, MLH_Note, MLH_StartDate, MLH_EndDate
from subtestlimitslog
inner join ModelLimitHistory on MLH_ID = Note_ID
where Station_name = @station and SAP_Model_Name = @model
union
select Station_Name,SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, getdate() as  Retire_Date, 
MLH_ID, MLH_Note, MLH_StartDate, MLH_EndDate
from subtestlimits
inner join ModelLimitHistory on MLH_ID = Note_ID
where Station_name = @station and SAP_Model_Name = @model
order by Limit_Date
GO