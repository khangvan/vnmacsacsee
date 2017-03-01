SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_GetSubAssemblies] 
	-- Add the parameters for the stored procedure here
@topserial char(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select tffc_serialnumber, tffc_reservedby as ACSSERIAL,
	part_no_name as SUBASSEMBLY, scanned_serial as SUBSERIAL, action_date as ACTIONDATE from tffc_serialnumbers
	inner join asylog on tffc_reservedby = acs_serial
	inner join catalog on added_part_no = part_no_count
	 where tffc_serialnumber  = @topserial
END
GO