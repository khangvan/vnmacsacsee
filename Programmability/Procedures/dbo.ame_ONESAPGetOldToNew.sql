SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ONESAPGetOldToNew]
 AS
set nocount on
select OneSapOldPart, OneSapNewPart, OneSapNewPartDescription  from onesapparttranslatefinal
GO