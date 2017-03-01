SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_InsertLatestBackFlushRecord]
@FFC_BackFlush_PO char(50), 
@FFC_BackFlush_POItem int, 
@FFC_BackFlush_Material char(20), 
@FFC_BackFlush_Qty int, 
@FFC_BackFlush_SerialNo char(20), 
@FFC_BackFlush_Date datetime,
@Vendor char(20),
@Plant char(10)
AS

insert into FFC_BackFlush_Current
(
FFC_BackFlush_PO, 
FFC_BackFlush_POItem, 
FFC_BackFlush_Material, 
FFC_BackFlush_Qty, 
FFC_BackFlush_SerialNo, 
FFC_BackFlush_Date,
FFC_BackFlush_Vendor,
FFC_BackFlush_Plant
)
values
(
@FFC_BackFlush_PO , 
@FFC_BackFlush_POItem , 
@FFC_BackFlush_Material , 
@FFC_BackFlush_Qty , 
@FFC_BackFlush_SerialNo , 
@FFC_BackFlush_Date,
@Vendor,
@Plant
)
GO