SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ame_ACSDebug_Log]
@station char(20),
@ACS_Serial char(20),
@PSC_Serial char(20),
@SAP_Model char(20),
@Next_Station char(20),
@Product_Name char(20),
@Shortie char(20),
@ProxyClass char(20),
@ProxyFunction char(20),
@intValue int,
@strValue char(30),
@Comment varchar(80)


 AS
set nocount on

insert into ACSDebugLog
(
Station, Log_date, ACS_Serial, PSC_Serial, SAP_Model, Next_Station, Product_Name,
 Shortie, ProxyClass, ProxyFunction,
 intValue, strValue, Comment
)
values
(
@station,
getdate(),
@ACS_Serial,
@PSC_Serial,
@SAP_Model,
@Next_Station,
@Product_Name,
@Shortie,
@ProxyClass,
@ProxyFunction,
@intValue,
@strValue,
@Comment
)


GO