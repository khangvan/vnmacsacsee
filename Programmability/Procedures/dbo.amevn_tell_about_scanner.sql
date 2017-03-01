SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
         -- =============================================
         -- Author:		/*Author*/
         -- Create date: /*Create Date*/
         -- Description:	/*Description*/
	    --         amevn_tell_about_scanner 'SK100997201'
         -- =============================================
         CREATE PROCEDURE [dbo].[amevn_tell_about_scanner] 
         @sn nchar(30)
         AS
         BEGIN
         	-- SET NOCOUNT ON added to prevent extra result sets from
         	-- interfering with SELECT statements.
         	--SET NOCOUNT ON;
		DECLARE @sntest nchar(30)
		SET @sntest =@sn



DECLARE @SQL NVARCHAR(200) SET @SQL = 'SELECT * FROM testlog WHERE acs_serial = @SN' 
eXEC sp_executesql @SQL, N'@sntest NVARCHAR(30)', @sntest = 'Smith'

PRINT @SQL
/* Execute Transact-SQL String */
EXECUTE(@SQL)
         
   --   select SAP_model, acs_Serial, station, pass_fail, FirstRun, Test_date_time from dbo.TestLog tl WHERE tl.ACS_Serial =	 @sn
	  --select sap_model, acs_serial, station, subtest_name, pass_fail, Test_pass_fail, strvalue, intvalue,floatValue, Units, Firstrun, test_date_time  from subtestlog_view sv
	  --WHERE ACS_Serial =	 @sn

	  --select TOP 1 * from testlog
         END
GO