SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO



CREATE  PROCEDURE [dbo].[sp_huy_kickercopy]
	@SourModel nvarchar(20),
	@DestModel nvarchar(20),
	@DestDesc nvarchar(70),
	@DestParam nvarchar(70),
	@DestCode nvarchar(10)
	
AS
	set nocount on

	if not exists (select * from TFFC_KICKER_TABLE where TFFC_KICKER_Model=@SourModel)
		begin
			select 'Source Model is not existed, please check!!!' as Notice
		end
	else if exists (select * from TFFC_KICKER_TABLE where TFFC_KICKER_Model=@DestModel)
		begin
			select 'Destinatino Model is not existed, please check!!!' as Notice
			select * from TFFC_KICKER_TABLE where TFFC_KICKER_Model=@DestModel
		end
	else
		begin
			insert into TFFC_KICKER_TABLE
			(TFFC_KICKER_Station, TFFC_KICKER_Model, TFFC_KICKER_Description, TFFC_KICKER_TestType, TFFC_KICKER_RunPath, TFFC_KICKER_DBPath, 
			TFFC_KICKER_SerialPortConfig, TFFC_KICKER_BinarySerialPortConfig, TFFC_KICKER_QBUDDIES, TFFC_KICKER_TMParameters, 
			TFFC_KICKER_TMCodice, TFFC_KICKER_Rework)
			select TFFC_KICKER_Station, 
			replace(TFFC_KICKER_Model, TFFC_KICKER_Model, @DestModel),
			replace(TFFC_KICKER_Description, TFFC_KICKER_Description, @DestDesc),
			TFFC_KICKER_TestType, TFFC_KICKER_RunPath, TFFC_KICKER_DBPath, TFFC_KICKER_SerialPortConfig, TFFC_KICKER_BinarySerialPortConfig, 
			TFFC_KICKER_QBUDDIES, 
			replace(TFFC_KICKER_TMParameters, TFFC_KICKER_TMParameters, @DestParam),
			replace(TFFC_KICKER_TMCodice, TFFC_KICKER_TMCodice, @DestCode),
			TFFC_KICKER_Rework
			from tffc_kicker_table
			where tffc_kicker_model=@SourModel

			select * from TFFC_KICKER_TABLE where TFFC_KICKER_Model=@DestModel
		end
GO