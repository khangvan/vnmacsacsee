SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO


CREATE proc [dbo].[sp_getyieldPCB]
-- Define input parameters
	@Station char(20),
	@SAPModel char(30)

-- Define code
AS


SELECT
	ACS_Serial,
	SAP_Model,
	Station,
	Test_ID,
	Pass_Fail,
	FirstRun,
	Test_Date_Time,
	ACSEEMode
FROM
	dbo.TestLog
WHERE
	(
	TL_ID IN
		(
		SELECT TOP 100 percent
			MIN(TL_ID) AS TL_ID
		FROM
			dbo.TestLog
		WHERE
			(Station =Ltrim(@Station)) and (SAP_Model=@SAPModel)
			and (substring(ACS_Serial,1,1)='S')
			--and (Test_Date_Time>'2002-05-01 23:37:03.000')
		GROUP BY
			ACS_Serial
		ORDER BY
			ACS_Serial
		)
	)
order by ACS_Serial






GO