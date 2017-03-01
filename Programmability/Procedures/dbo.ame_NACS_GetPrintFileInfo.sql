SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NACS_GetPrintFileInfo]
@Station char(20),
@BOMFile char(20)
 AS
set nocount on

select 
PRF_ID, PRF_BomPartName, PRF_Station, PRF_ProductLine, PRF_PrintFileName, PRF_DoPrint, PRF_DemandOrPrePrint
from NACS_PrintFileLookup
where PRF_BomPartName = @BOMFile and PRF_Station = @Station
GO