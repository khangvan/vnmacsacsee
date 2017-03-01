SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ameNET_getLocationInfo] AS
set nocount on

select ACSEELocation, ACSEEConnectionString, ACSEEClientStateLocation, ACSEEClientStateConnectionString, ACSEEStateLocation, ACSEEStateConnectionString from NETLocationInfo
GO