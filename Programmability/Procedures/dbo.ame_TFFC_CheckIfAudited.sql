SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_CheckIfAudited]
@acsserial char(20)
AS
set nocount on

declare @auditcount int


set @auditcount = 0

select @auditcount = count(*) from testlog where rtrim(acs_serial) = (@acsserial)  and station like '%AUDIT%'

select @auditcount as count
GO