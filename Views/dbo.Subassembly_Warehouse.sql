SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE VIEW [dbo].[Subassembly_Warehouse]
AS
select * from top_model_warehouse
where top_model_warehouse.ACS_Serial in
(select asylog_summary_warehouse.Sub_ACS_Serial from asylog_summary_warehouse)


GO