SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_Get_AuditFrus]
@productline char(20)
 AS
set nocount on


select * from SAP_NewRepairFrus
where RFU_Type = 3
and RFU_Productline = @productline
GO