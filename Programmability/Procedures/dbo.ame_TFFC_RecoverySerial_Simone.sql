SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_RecoverySerial_Simone]
@SapSerial char(20),
@AcsSerial char(20),
@Restore char(5)

 AS

set nocount on

declare @acsSer char(20)
declare @newSer char(20)
declare @result char(10) 
declare @tffcid int
    
begin transaction

if exists (select TFFC_ID from TFFC_SerialNumbers WITH (TABLOCKX)  where TFFC_SerialNumber = @SapSerial )
  begin
    select @tffcid = TFFC_ID, @acsSer=TFFC_ACSSerial from TFFC_SerialNumbers where TFFC_SerialNumber = @SapSerial 
    if rtrim(@acsSer) = rtrim(@AcsSerial)
	  begin
        update TFFC_SerialNumbers set TFFC_Consumed = 0, TFFC_Reserved=0, TFFC_ReservedBy='', TFFC_ACSSerial='' where TFFC_ID = @tffcid
		
		if rtrim(@Restore)='TRUE'
		  begin
			if exists (select * from  ACSEEState.dbo.loci WITH (TABLOCKX)  where PSC_Serial = @SapSerial )
			  begin
			    set @newSer = '#'+rtrim(@SapSerial)
				update ACSEEState.dbo.loci set PSC_Serial=@newSer where PSC_Serial = @SapSerial
				set @result='OK2'  --unreserved and restored
			  end
		  end
        else
          begin
		    set @result='OK1'  --only unreserved
          end		  
	  end	
	else
	  begin
	    if rtrim(@acsSer)=''
		  begin
		    if rtrim(@Restore)='TRUE'
			  begin
				if exists (select * from  ACSEEState.dbo.loci WITH (TABLOCKX)  where PSC_Serial = @SapSerial )
				  begin
					set @newSer = '#'+rtrim(@SapSerial)
					update ACSEEState.dbo.loci set PSC_Serial=@newSer where PSC_Serial = @SapSerial
					set @result='OK3'  --only restored
				  end
				else
				  begin
					set @result='ERROR1' -- no entries in Loci
				  end
			  end
			else
			  begin
			    update TFFC_SerialNumbers set TFFC_Consumed = 0, TFFC_Reserved=0, TFFC_ReservedBy='', TFFC_ACSSerial='' where TFFC_ID = @tffcid
			    set @result='OK1' --only unreserved
			  end
		  end
		else
		  begin
		    set @result='ERROR2'	--different traveller values between tffc_serialnumbers and loci	  
		  end
	  end
  end
else
  begin
    set @result = 'NOUPDATE'  --no action taken
  end

commit transaction

select @result as Result
GO