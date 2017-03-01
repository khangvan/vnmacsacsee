SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ameNET_GetAllPrintModels] 
AS
set nocount on
select  NACS_PrintModel_Name from NACS_PrintModels

select NACS_Culture from NACS_Cultures
GO