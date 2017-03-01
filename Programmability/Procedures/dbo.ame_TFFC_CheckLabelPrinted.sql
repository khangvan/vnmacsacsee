SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ame_TFFC_CheckLabelPrinted] 
	@acsserial char(20),
	@pscserial char(20),
	@printcount int OUTPUT
AS
BEGIN
	SET NOCOUNT ON
     
	declare @tableacsserial char(20)
	declare @tablepscserial char(20)

	declare @tffcid int

	select @tffcid = TFFC_ID from TFFC_SerialNumbers where Tffc_SerialNumber = @pscserial
	if @tffcid is not null
	begin
	   select @tableacsserial = tffc_travellerprintedwith from tffc_serialnumbers where tffc_id = @tffcid
	   select @printcount = isnull(TFFC_LabelPrinted,0) from tffc_serialnumbers where tffc_id = @tffcid

	   if @printcount = 0 
	   begin
	       update tffc_serialnumbers set tffc_travellerprintedwith = @acsserial,  tffc_labelprinted = 1 where tffc_id = @tffcid
		   set @printcount = 1
		   select 'OK'
	   end
--	   if @tableacsserial = @acsserial
--	   begin
--	       select 'OK'
--	   end
	   else
	   begin
	      select 'ALREADY PRINTED'
	   end
	end
	else
	begin
	   select 'NOT FOUND'
	end


END

GO