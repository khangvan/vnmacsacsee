SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TRN_fixtffcserialnumbers]
 AS
set nocount on

insert into TRN_TFFC_SerialNumbers
(
TFFC_ID, TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, 
TFFC_Reserved, TFFC_Reservedby, TFFC_Consumed, TFFC_ConsumedDate, 
TFFC_Material, TFFC_Description, TFFC_ACSSErial, 
TFFC_StationConsumedAt, TFFC_Period
)
select 
TFFC_ID, TFFC_ProdOrder, TFFC_SerialNumber, TFFC_RefreshDate, 
TFFC_Reserved, TFFC_Reservedby, TFFC_Consumed, TFFC_ConsumedDate, 
TFFC_Material, TFFC_Description, TFFC_ACSSErial, 
TFFC_StationConsumedAt, TFFC_Period
 from TRN_Stage_TFFC_SerialNumbers
where TFFC_ProdOrder in
(
select distinct TFFC_ProdOrder from TRN_Stage_TFFC_SerialNumbers 
where tffc_prodorder not in
(
select distinct tffc_prodorder from TRN_TFFC_SerialNumbers 
)
)

truncate table TRN_Stage_TFFC_SerialNumbers
GO