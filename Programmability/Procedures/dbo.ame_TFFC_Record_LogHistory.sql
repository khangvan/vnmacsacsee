SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_Record_LogHistory]
@ProdOrder nchar(20),
@serial char(20),
@refreshdate datetime,
@reserved int,
@reservedby char(20),
@consumed int,
@consumeddate datetime,
@material char(20),
@description char(50),
@acsserial char(20),
@stationconsumed char(20) ,
@period char(20),
@logdate datetime,
@reason1 char(80),
@reason2 char(80)
 AS

set nocount on


insert into TFFC_LogHistory_SerialNumbers
(
TFFC_ProdOrder, TFFC_SerialNumber, 
TFFC_RefreshDate, TFFC_Reserved, TFFC_Reservedby, 
TFFC_Consumed, TFFC_ConsumedDate, TFFC_Material, 
TFFC_Description, TFFC_ACSSErial, TFFC_StationConsumedAt, 
TFFC_Period, TFFC_LogDate, TFFC_Reason1, TFFC_Reason2
)
values
(
@ProdOrder ,
@serial ,
@refreshdate ,
@reserved ,
@reservedby ,
@consumed ,
@consumeddate ,
@material ,
@description ,
@acsserial ,
@stationconsumed  ,
@period ,
@logdate ,
@reason1 ,
@reason2 
)
GO