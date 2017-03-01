SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_spc_get_last_specgroup_update]
@model_name char(20)
as

select top 1 spcsgs_date from SPCSpecMembers where sap_model_name=@model_name order by spcsgs_date desc
GO