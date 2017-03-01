SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[amevn_checkNaddXME]
 @Part varchar(30) ='5-2809'
, @Station varchar(50)='ACSVNHUYREMOTE'
AS
BEGIN
	

	
--DECLARE @Part varchar(30)
--DECLARE @Station varchar(50)

DECLARE @PartCheck varchar(30)
DECLARE @IsSet int = 0

---test
--SET @Part='5-2809'
--SET @Station='ACSVNHUYREMOTE'
Set @PartCheck = rtrim(@Part)+'XME'


SELECT @IsSet= count(*)
FROM       dbo.Partlist 
INNER JOIN dbo.[Catalog] ON dbo.Partlist.Part_No = dbo.[Catalog].Part_No_Count
INNER JOIN dbo.Stations  ON dbo.Partlist.Station = dbo.Stations.Station_Count
WHERE part_no_name =@PartCheck AND station_name =@Station

IF @IsSet != 0 
SELECT 'OK' AS Result
;
ELSE
SELECT 'NG' AS Result
;
END
GO