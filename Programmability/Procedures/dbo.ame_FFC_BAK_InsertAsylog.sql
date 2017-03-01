SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_InsertAsylog]
@ACS_Serial char(20), 
@Station int, 
@Action smallint, 
@Added_Part_No int, 
@Scanned_Serial char(20), 
@Rev char(2), 
@Action_Date datetime, 
@Quantity int, 
@asylog_ID int
 AS


insert into FFC_BAK_Asylog
(
ACS_Serial, 
Station, 
Action, 
Added_Part_No, 
Scanned_Serial, 
Rev, 
Action_Date, 
Quantity, 
asylog_ID
)
values
(
@ACS_Serial, 
@Station, 
@Action, 
@Added_Part_No, 
@Scanned_Serial, 
@Rev, 
@Action_Date, 
@Quantity, 
@asylog_ID
)
GO