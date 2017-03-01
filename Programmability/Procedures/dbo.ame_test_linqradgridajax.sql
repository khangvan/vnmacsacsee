SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_test_linqradgridajax]
@maxtlid int,
@mindate datetime
 AS

set nocount on
select  station, sap_model, acs_serial, pass_fail, test_date_time from testlog
where tl_id > @maxtlid
GO