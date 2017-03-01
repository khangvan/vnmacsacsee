SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_ReserveSerial]
@ProdOrder char(20),
@acsserial char(20),
@material char(20),
@station char(20),
@serial char(20) OUTPUT
AS

	set nocount on
		declare @lociacsserial char(20)
		declare @strLog1 char(300)
		declare @strLog2 char(300)
		declare @strLog3 char(300)

		declare @usedtffcID int
		declare @tffcID int

	begin transaction
		begin transaction
			select @lociacsserial=ACS_Serial from [ACSEESTATE].[dbo].loci
			WITH (TABLOCKX)  where ProdOrder = @ProdOrder and SAP_Model=rtrim(@material) and ACS_Serial=rtrim(@acsserial)
		commit transaction

		begin transaction
			if @lociacsserial is not null
			begin 
				select @usedtffcID = tffc_id from tffc_serialnumbers  where rtrim(TFFC_ProdOrder) = rtrim(@ProdOrder) and rtrim(tffc_reservedby) = rtrim(@acsserial)
  
				if @usedtffcID is not null -- the ACS Serial is already associated to a SAP serial in the  production order
				begin
					select @serial = tffc_serialnumber from tffc_serialnumbers where tffc_id = @usedtffcID
				end
				else   -- no serial is associated with the given ACS serial number, get an available on
				begin
					begin transaction
						select @tffcID =  min(TFFC_ID) from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder and TFFC_Consumed = 0 and TFFC_Reserved = 0
	--					set @strLog1 = 'reserve1 pid=' + convert(varchar, @@SPID) + ' prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@tffcID,0)) +']'


	--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"
	/*
				insert into TFFC_ReserveLog
				(
					LogTime,
					LogRecord,
				   ACSSerial
				 )
				values
				(
					getdate(),
				   @strLog1,
				   @acsserial
				)
	*/
						if @tffcID is not null   -- if a free serial is found reserve it and return
						begin
							begin transaction
							select @serial = TFFC_SerialNumber from TFFC_SerialNumbers where TFFC_ID = @tffcID
							update TFFC_SerialNumbers set TFFC_Reserved =1, TFFC_Reservedby=@acsserial, TFFC_ReservedTime = getdate() where TFFC_ID = @tffcID
							commit transaction
	--						set @strLog2 = 'reserve2 pid=' + convert(varchar,@@SPID) + '   prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   =[' + convert(varchar,isnull(@tffcID,0)) +'] aserial=[' + isnull(@serial,'') + ']'
	/*                  insert into TFFC_ReserveLog
					  (
						 LogTime,
						 LogRecord,
						ACSSerial,
						SAPSerial
					 )
					values
					(
						getdate(),
					   @strLog2,
					   @acsserial,
					   @serial
					)
	*/
						end
						else
						begin
							set @serial ='BAD'
							if exists ( select top 1 TFFC_ID from TFFC_SerialNumbers where TFFC_ProdOrder = @ProdOrder )
							begin
								set @serial='FUL'
							end
						end
					commit transaction
	--			set @strLog3 = 'reserve3 pid=' + convert(varchar,@@SPID) + '   prodorder=[' + isnull(@ProdOrder,'') +']  acsserial=[' + isnull(@acsserial,'') +']   =[' + convert(varchar,isnull(@tffcID,0)) +'] aserial=[' + isnull(@serial,'') + ']'
	/* 
		 insert into TFFC_ReserveLog
		  (
			   LogTime,
			   LogRecord,
			  ACSSerial,
			  SAPSerial,
			  ReturnedSerial
		 )
		 values
		  (
			  getdate(),
			 @strLog3,
			@acsserial,
			@serial,
			@serial
		  )
	*/
					end  -- end acquire available serial number
				end
				else -- no loci acs serial
				begin
					set @serial='WRONG'
				end
			commit transaction
		select @serial as serial
	commit transaction
GO