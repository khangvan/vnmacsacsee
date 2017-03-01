SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetCOntrolledSubAssemblies]
@model char(20)
 AS
set nocount on

select TFFC_KICKSUB_Model, TFFC_KICKSUB_Part,TFFC_KICKSUB_Station, TFFC_KICKSUB_Location from TFFC_KICKSUB
where rtrim(TFFC_KICKSUB_Model) =rtrim(@model)
GO