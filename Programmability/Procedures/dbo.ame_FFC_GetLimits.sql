SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetLimits]
@Vendor char(20) = '104341',
@Plant    char(10)='1000'
 AS
select Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Limit_ID, Note_ID, OpportunitiesforFail
from FFC_EUG_Subtestlimits
where FFC_SO_Vendor = @Vendor and FFC_SO_Plant = @Plant
GO