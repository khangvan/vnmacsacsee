SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupModelsSubTestLimits]
@model char(20)
 AS
select * from subtestlimits where sap_model_name = @model
GO