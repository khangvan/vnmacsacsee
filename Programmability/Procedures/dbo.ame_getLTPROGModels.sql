SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getLTPROGModels] 
AS
set nocount on
select  distinct 'LTPROG1', 
sap_model as MATERIAL from testlog where station like 'LTPRO%'
union
select 'LTPROG1', '662859011'
union
select 'LTPROG1','662859030'
order by MATERIAL
GO