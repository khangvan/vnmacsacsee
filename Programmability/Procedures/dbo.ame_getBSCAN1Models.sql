SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getBSCAN1Models] 
AS
set nocount on
select  distinct 'BSCAN11', 
sap_model as MATERIAL from testlog where station like 'bsca%'
and sap_model not like '66%'
union
select 'BSCAN11','3-0998-06-ELG'
union
select 'BSCAN11','3-0998-14-ELG'
union
select 'BSCAN11','3-1025-04'
union
select 'BSCAN11','3-1021-02'
union
select 'BSCAN11','3-1021-04'
union
select 'BSCAN11','3-1021-06'
union
select 'BSCAN11','3-1021-16'
union
select 'BSCAN11','3-1021-20'
union
select 'BSCAN11','3-1117-06'
union
select 'BSCAN11','3-1088-06'
union
select 'BSCAN11','3-1112-04'
union
select 'BSCAN11','662904010'
union
select 'BSCAN11','662904030'
union
select 'BSCAN11', '662772010'
union
select 'BSCAN11','662783011'
union
select 'BSCAN11','662904031'
union
select 'BSCAN11','662904041'
union
select 'BSCAN11','662802013'
union
select 'BSCAN11','662802022'
union
select 'BSCAN11','662783012'
union
select 'BSCAN11','662907012'
union 
select 'BSCAN11','662859011'
--union
--select 'BSCAN11','662802014'
--union
--select 'BSCAN11','662802023'
order by MATERIAL
GO