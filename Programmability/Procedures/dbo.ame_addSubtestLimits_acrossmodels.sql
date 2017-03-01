SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_addSubtestLimits_acrossmodels]
 AS

declare @mymodel varchar(20)

declare cur_models
cursor for
select distinct sap_model_name from subtestlimits 
where station_name = 'riggsbf_config'
--and  ( sap_model_name like '844%'  )


open cur_models
fetch next from cur_models into @mymodel
while @@FETCH_STATUS = 0
begin
print @mymodel


exec ame_AddUpdate_limit
'riggsbf_config',
'ShekelUSCal',
@mymodel ,
'S',
0.0,
0.0,
' ',
'',
'',
'SheklUSScaleCal',
'psc\rlp',
0,
'N',
0.0,
0.0,
'8/27/2009 4:00 PM' ,
0


fetch next from cur_models into @mymodel
end

close cur_models
deallocate cur_models
GO