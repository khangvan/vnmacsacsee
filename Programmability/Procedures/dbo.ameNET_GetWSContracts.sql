SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ameNET_GetWSContracts] AS
set nocount on

select WS_Contract_ID, WS_Contract_SymbolicName, WS_Contract_RealName, WS_Contract_Note
 from dbo.WS_ContractNames
GO