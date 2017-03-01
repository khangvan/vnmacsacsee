SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Add_OverridePart]
@station char(20),
@model char(20),
@nchars int,
@part char(20),
@notes char(50),
@user char(50)
 AS
set nocount on
insert into BOMOverrides_Parts
(
BOMO_Station,
BOMO_Model,
BOMO_Chars,
BOMO_Part,
BOMO_Notes,
BOMO_user
)
values
(
@station,
@model,
@nchars,
@part,
@notes,
@user
)
GO