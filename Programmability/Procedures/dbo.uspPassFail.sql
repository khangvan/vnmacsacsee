SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



CREATE       PROCEDURE [dbo].[uspPassFail]
	(
		@DaysBack_1	int = 0,
		@r	varchar(1) = ''
	)
	
AS

DECLARE
	@mBasesql varchar(4000),
	@sumcol varchar(50),
	@sql varchar(8000),
	@NEWLINE char(1),
	@keyssql varchar(1000),
	@key varchar(100),
	@fromdate varchar(50)

CREATE TABLE 
	#mBase
		(
			ACS_Serial varchar(20),
			Pass_Fail varchar(1),
			Station varchar(20)
		)
CREATE TABLE
	#keys
		(
			keyvalue nvarchar(100) NOT NULL PRIMARY KEY
		)

SET @NEWLINE = CHAR(10)
SET @fromdate = CAST(getdate() - @DaysBack_1 AS varchar(50))
SET @sumcol = NULL
SET @mBasesql =
	'INSERT INTO #mBase ' + @NEWLINE +
	'SELECT TOP 100 PERCENT ' + @NEWLINE +
	'	RTrim(CAST(ACS_Serial AS varchar(20))) AS ACS_Serial, ' + @NEWLINE +
	'	RTrim(CAST(Pass_Fail AS varchar(1))) AS Pass_Fail, ' + @NEWLINE +
	'	RTRIM(CAST(Station AS varchar(20))) AS Station ' + @NEWLINE +
	'FROM ' + @NEWLINE +
	'	dbo.TestLog ' + @NEWLINE +
	'WHERE ' + @NEWLINE +
	'	( ' + @NEWLINE +
	'	TL_ID IN ' + @NEWLINE +
	'		( ' + @NEWLINE +
	'		SELECT TOP 100 PERCENT ' + @NEWLINE +
	'			MIN(TL_ID) AS TL_ID ' + @NEWLINE +
	'		FROM ' + @NEWLINE +
	'			dbo.TestLog ' + @NEWLINE +
/*	'		WHERE ' + @NEWLINE +
	'			( ' + @NEWLINE +
	'				MONTH(Test_Date_Time) = MONTH(''' + @fromdate + ''') ' + @NEWLINE +
	'			) ' + @NEWLINE +
	'			AND ' + @NEWLINE +
	'			( ' + @NEWLINE +
	'				 YEAR(Test_Date_Time) = YEAR(''' + @fromdate + ''') ' + @NEWLINE +
	'			) ' + @NEWLINE +
	'			AND ' + @NEWLINE +
	'			( ' + @NEWLINE +
	'				DAY(Test_Date_Time) ' + @r + '= DAY(''' + @fromdate + ''') ' + @NEWLINE +
	'			) ' + @NEWLINE +
*/
	'		GROUP BY ACS_Serial, Station' + @NEWLINE +
	'		ORDER BY ACS_Serial ' + @NEWLINE +
	'		) ' + @NEWLINE +
	'	) ' + @NEWLINE +
	'ORDER BY ACS_Serial'
	
--print @mBasesql
--return
EXEC (@mBasesql)

--select * from #mBase
--return

SET @sql =
	'SELECT TOP 100 PERCENT Station'

SET @keyssql = 
	'INSERT INTO #keys ' +
	'SELECT DISTINCT Pass_Fail FROM #mBase '
	
EXEC (@keyssql)

SELECT @key = MIN(keyvalue) FROM #keys

WHILE @key IS NOT NULL
BEGIN
	SET @sql = @sql + ','                   + @NEWLINE +
		'  SUM(CASE CAST(Pass_Fail AS nvarchar(100))' + @NEWLINE +
		'        WHEN N''' + @key +
		   ''' THEN ' + CASE
				  WHEN @sumcol Is Null THEN '1'
				  ELSE '0'
				END + @NEWLINE +
		'        ELSE 0'                      + @NEWLINE +
		'      END) AS ' + @key

	SELECT @key = MIN(keyvalue) FROM #keys
	WHERE keyvalue > @key
END

SET @sql = @sql + @NEWLINE +
	'FROM #mBase'     + @NEWLINE +
	'GROUP BY Station' + @NEWLINE +
	'ORDER BY Station'

--print @sql
--return



EXEC (@sql)







GO