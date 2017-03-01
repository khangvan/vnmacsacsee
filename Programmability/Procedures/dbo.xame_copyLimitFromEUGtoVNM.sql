SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[xame_copyLimitFromEUGtoVNM]
@model as char(20)
 AS
set nocount on


declare @hr1 int
declare @hr2 int
declare @hr3 int
declare @hr4 int
declare @outconnect int
declare @oPKG int

select 1
--EXEC @hr1 = sp_OACreate 'DTS.Package', @oPKG OUT


--EXEC @hr2 = sp_OAMethod @oPKG,  'LoadFromSQLServer("VNMACSDB", "","",256,,,, "CopyOneModelLimitsFromEugToVNM")', null



--EXEC @hr3 = sp_OASetProperty @oPKG, 'GlobalVariables("modelnumber").Value', @model


--EXEC @hr4 = sp_OAMethod @oPKG, 'Execute'
GO