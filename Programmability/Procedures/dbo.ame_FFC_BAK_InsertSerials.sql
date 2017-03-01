SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_BAK_InsertSerials]
@FFC_BAK_ID int, 
@FFC_BAK_pscserial nchar(20), 
@FFC_BAK_acsserial nchar(50), 
@FFC_BAK_model nchar(30), 
@FFC_BAK_SalesOrder nchar(30)
  AS
set nocount on

insert into FFC_BAK_Serials
(
FFC_BAK_ID, 
FFC_BAK_pscserial, 
FFC_BAK_acsserial, 
FFC_BAK_model, 
FFC_BAK_SalesOrder
)
values
(
@FFC_BAK_ID, 
@FFC_BAK_pscserial, 
@FFC_BAK_acsserial, 
@FFC_BAK_model, 
@FFC_BAK_SalesOrder
)
GO