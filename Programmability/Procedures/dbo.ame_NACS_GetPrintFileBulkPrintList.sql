SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NACS_GetPrintFileBulkPrintList]

 AS
set nocount on

select distinct PRF_ID, PRF_BomPartName, PRF_Station, PRF_ProductLine, PRF_PrintFileName, PRF_DoPrint, isnull(PRF_BulkPrintFile,'0') as PRF_BulkPrintFile, PRF_Ribbon, PRF_Paper, PRF_Machine, PRF_User, PRF_Variable1
from NACS_PrintFileLookup
--where PRF_BulkPrintFile = 1
/*
select 
PRF_ID, PRF_BomPartName, PRF_Station, PRF_ProductLine, PRF_PrintFileName
from NACS_PrintFileLookup
where  PRF_Station = @Station
*/
GO