SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getBSCANModels] 
AS
set nocount on

select  distinct 'BSCAN0', 
sap_model as MATERIAL from testlog where station like 'bsca%'
and sap_model not like '66%'
union
select 'BSCAN0','3-1025-04'
union
select 'BSCAN0','3-1021-02'
union
select 'BSCAN0','3-1021-04'
union
select 'BSCAN0','3-1021-06'
union
select 'BSCAN0','3-1021-16'
union
select 'BSCAN0','3-1021-20'
union
select 'BSCAN0','3-1117-06'
union
select 'BSCAN0','3-1088-06'
union
select 'BSCAN0','3-1112-04'
union
select 'BSCAN0','662904010'
union
select 'BSCAN0','662904030'
union
select 'BSCAN0', '662772010'
union
select 'BSCAN0','662783011'
union
select 'BSCAN0','662904031'
union
select 'BSCAN0','662904041'
union
select 'BSCAN0','662802013'
union
select 'BSCAN0','662802022'
union
select 'BSCAN0','662783012'
union
select 'BSCAN0','662907012'
union 
select 'BSCAN0','662859011'
--union
--select 'BSCAN0','662802014'
--union
--select 'BSCAN0','662802023'
--union
--select  'ACSPANGRYBASEST','740021403'
--union
--select  'ACSPANGRYBASEST','740021402'
union

select  'ACSPANGRYBASEST','700005304' AS MATERIAL
union
select  'ACSPANGRYCAP','740021403' AS MATERIAL 
union
select  'ACSPANGRYCAP','740021402' AS MATERIAL 
union
select  'ACSPANGRYCAP','740021401' AS MATERIAL 
--union
--select  'ACSPANGRYCAP','700005304' 
order by MATERIAL
GO