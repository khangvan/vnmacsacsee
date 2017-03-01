SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ame_load_newProducts] AS
set ANSI_NULLS ON
set ANSI_WARNINGS ON
declare cur_ReportProducts CURSOR FOR
select PRD_SAPModelName from [VNMACSRPT].[ACSEEReports].[dbo].Products
where PRD_SAPModelName not in ( select SAP_Model_Name from products)

declare @SAPModelname char(20)


open cur_ReportProducts
fetch next from cur_ReportProducts into @SAPModelname
WHILE @@FETCH_STATUS = 0
begin

exec ame_create_label_format @SAPModelname

fetch next from cur_ReportProducts into @SAPModelname
end

close cur_ReportProducts

deallocate cur_ReportProducts
GO