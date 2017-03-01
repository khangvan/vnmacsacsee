SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_CreateRandyLimits] 
AS



declare @modelname char(20)
declare cur_allmodels  cursor for
select distinct sap_model_name from subtestlimits where station_name like 'HawkeyeConf%'


open cur_allmodels

FETCH next from cur_allmodels into @modelname
WHILE @@FETCH_STATUS = 0
begin
   exec ame_AddUpdate_Limit 'HawkeyeConfig', 'Product', @modelname,'S',0,0,'Hawk_SRI','Y',' ','Hawk_SRI or_2D','RPerson',0,'N',0,0,'4/3/2006',0
FETCH next from cur_allmodels into @modelname
end
close cur_allmodels
deallocate cur_allmodels
GO