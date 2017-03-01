SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NACS_getPrinterFieldNames] 
AS
set nocount on
select
PF_ID, PF_Name, 
PF_MatrixName, PF_Modifier, PF_Type
from NACS_PrinterFieldnames
GO