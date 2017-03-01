SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_ClearCOFOrigin]
as
set nocount on
truncate table FFC_COFOrigin
GO