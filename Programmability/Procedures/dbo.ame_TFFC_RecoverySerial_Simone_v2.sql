SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE PROCEDURE [dbo].[ame_TFFC_RecoverySerial_Simone_v2]
@ACS_Serial		char(20) = NULL 	-- ACS_Serial

AS
set nocount on

declare @Sap_Serial char(20)
declare @Completed_Traveller char(20)
declare @myCount int
declare @result char(10) 

set @Sap_Serial = ''
set @Completed_Traveller = ''
set @myCount=0




begin transaction

if not Exists (select * from [ACSEEState].[dbo].Loci where ACS_Serial=@ACS_Serial)
begin
	set @result = 'NOTRAVELER' -- the traveler doesn't exists
end
else
begin
	if Exists (select * from [ACSEEState].[dbo].Loci where ACS_Serial=@ACS_Serial and Next_Station_Name='TMTEST')
	begin
		select @Sap_Serial=PSC_Serial 
		from [ACSEEState].[dbo].Loci
		where ACS_Serial=@ACS_Serial
	
		if rtrim(ltrim(@Sap_Serial)) <>''
		begin 
			select @myCount=count(ACS_Serial)
			from [ACSEEState].[dbo].Loci
			where (PSC_Serial=@Sap_Serial and Next_Station_Name<>'TMTEST' and ACS_Serial<>@ACS_Serial)
			group by ACS_Serial
		
			if @myCount=1
			begin
				select @Completed_Traveller=min(ACS_Serial)
				from [ACSEEState].[dbo].Loci
				where PSC_Serial=@Sap_Serial and Next_Station_Name<>'TMTEST' and ACS_Serial<>@ACS_Serial
			
				update [ACS EE].[dbo].Tffc_SerialNumbers
				set tffc_reserved=1, tffc_consumed=1, tffc_reservedby=@Completed_Traveller, tffc_ACSSerial=@Completed_Traveller
				where Tffc_SerialNumber=@Sap_Serial
			
				update [ACSEEState].[dbo].Loci
				set PSC_Serial=''
				where ACS_Serial=@ACS_Serial
			
				set @result = 'OK'
			end
			else
			begin 
				if @myCount>1
				begin
					set @result = 'ERROR'  -- Call Bill, Doug or Simone
				end
				else
				begin
					update [ACS EE].[dbo].Tffc_SerialNumbers
					set tffc_reserved=0, tffc_consumed=0, tffc_reservedby='', tffc_ACSSerial=''
					where Tffc_SerialNumber=@Sap_Serial
				
					update [ACSEEState].[dbo].Loci
					set PSC_Serial=''
					where ACS_Serial=@ACS_Serial
				
					set @result = 'OK'
				end
			
			end
		end
		else
		begin
			set @result = 'NOSERIAL'--no SAP serial assigned to this traveller
		end
	end
	else
	begin 
		set @result = 'NOERROR' -- the traveler now in down the line
	end
end


commit transaction

select @result as Result
GO