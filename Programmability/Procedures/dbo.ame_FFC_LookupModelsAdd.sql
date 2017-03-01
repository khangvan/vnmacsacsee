SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_LookupModelsAdd]
@sapmodel char(20)
 AS
insert into FFC_LookupModels
(
FFC_Lookup_Model
)
values
(
@sapmodel
)
GO