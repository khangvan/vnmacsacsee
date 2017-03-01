SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NACS_GetPrintFileList]

 AS
set nocount on

select distinct PRF_ProductLine,PRF_PrintFileName
from NACS_PrintFileLookup
/*
select 
PRF_ID, PRF_BomPartName, PRF_Station, PRF_ProductLine, PRF_PrintFileName
from NACS_PrintFileLookup
where  PRF_Station = @Station
*/
GO