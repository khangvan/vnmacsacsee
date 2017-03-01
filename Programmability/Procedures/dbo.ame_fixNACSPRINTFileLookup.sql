SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_fixNACSPRINTFileLookup]
 AS
set nocount on

declare cur_fix cursor for
select PRF_ID, prf_station from NACS_PrintFIleLookup
where prf_station like 'ACSUS%'

declare @id int
declare @origstation char(20)
declare @newstation char(20)


open cur_fix
FETCH next from cur_fix into @id, @origstation
while @@FETCH_STATUS = 0
begin
set @newstation = 'ACSVN' + substring(@origstation,6, len(@origstation))
print @newstation
update NACS_PrintFileLookup set prf_station = @newstation where PRF_ID = @id
FETCH next from cur_fix into @id, @origstation
end

close cur_fix
deallocate cur_fix
GO