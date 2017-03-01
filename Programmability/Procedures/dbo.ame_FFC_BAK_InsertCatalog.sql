SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE  [dbo].[ame_FFC_BAK_InsertCatalog]
@Part_No_Count int, 
@Part_No_Name char(20), 
@Description nchar(40), 
@Status char(1), 
@FactoryGroup_Mask int, 
@ProductGroup_Mask int
 AS

insert into FFC_BAK_Catalog
(
Part_No_Count, 
Part_No_Name, 
Description, 
Status, 
FactoryGroup_Mask, 
ProductGroup_Mask
)
values
(
@Part_No_Count, 
@Part_No_Name, 
@Description, 
@Status, 
@FactoryGroup_Mask, 
@ProductGroup_Mask
)
GO