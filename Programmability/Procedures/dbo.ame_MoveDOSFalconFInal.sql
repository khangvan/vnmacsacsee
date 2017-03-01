SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_MoveDOSFalconFInal] 
AS
declare @sapmodel char(20)

declare cur_Models CURSOR FOR
SELECT Digits from [ACSEESTate].[dbo].Option_7

open cur_Models
FETCH NEXT FROM cur_Models into @sapmodel
WHILE @@FETCH_STATUS = 0
BEGIN
print @sapmodel
FETCH NEXT FROM cur_Models into @sapmodel
END
close cur_Models
deallocate cur_Models
GO