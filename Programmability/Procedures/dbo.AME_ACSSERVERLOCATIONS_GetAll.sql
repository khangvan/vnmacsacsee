SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[AME_ACSSERVERLOCATIONS_GetAll]
 AS
set nocount on
select ACS_Location_ID, ACS_Location_Name, ACS_Location_DB, ACS_Location_ConnectStr, ACS_Location_SAPLocation from ACSServerLocations
GO