SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_CLEARALLTESTTABLES] AS

set nocount on

truncate table FFC_SalesOrders
truncate table [ACSEEClientState].[dbo].FFC_Parts_Level
truncate table FFC_subtestlimits

truncate table [ACSEESTATE].[dbo].FFC_option_0
truncate table [ACSEESTATE].[dbo].FFC_option_1
truncate table [ACSEESTATE].[dbo].FFC_option_2
truncate table [ACSEESTATE].[dbo].FFC_option_3
truncate table [ACSEESTATE].[dbo].FFC_option_4
truncate table [ACSEESTATE].[dbo].FFC_option_5
truncate table [ACSEESTATE].[dbo].FFC_option_6
truncate table [ACSEESTATE].[dbo].FFC_option_7
truncate table [ACSEESTATE].[dbo].FFC_option_8
truncate table [ACSEESTATE].[dbo].FFC_option_9
truncate table [ACSEESTATE].[dbo].FFC_Power
truncate table [ACSEESTATE].[dbo].FFC_ROHSExceptions
truncate table [ACSEESTATE].[dbo].FFC_Scale
truncate table [ACSEESTATE].[dbo].FFC_SInterface
truncate table [ACSEESTATE].[dbo].FFC_SModel
truncate table [ACSEESTATE].[dbo].FFC_Tops
truncate table [ACSEESTATE].[dbo].FFC_Config
truncate table [ACSEESTATE].[dbo].FFC_FormatFile
truncate table [ACSEESTATE].[dbo].FFC_Formats
truncate table [ACSEESTATE].[dbo].FFC_Interface
truncate table [ACSEESTATE].[dbo].FFC_Matrix_Parsing
truncate table [ACSEESTATE].[dbo].FFC_Matrix_Parsing_Select


truncate table FFC_PrintDirectories
truncate table FFC_COFOrigin
GO