SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_GetOverPackBoxes]
 AS
set nocount on

select OverPackBox_ID, 
OverPackBox_ProductFamily,
OverPackBox_HandlingUnit, 
OverPackBox_ItemDescription, 
OverPackBox_Units, 
OverPackBox_Length, 
OverPackBox_Width, 
OverPackBox_Height
from OverPackBox
GO