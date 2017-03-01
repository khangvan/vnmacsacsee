SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[ame_TFFC_TransferOrder_GetModel_Passing]
@pscserial char(20),
@checkforpassingrecord int 
AS
set nocount on




declare @assemid int
declare @acsserial char(20)
declare @lociacsserial char(20)
declare @test_TL_ID int
declare @modelid int
declare @model char(20)
declare @passed int
declare @passfailresult char(3)

declare @confirmstation char(20)
declare @confirmpassfail char(20) 
declare @confrimOK char(20) 

set @passed = -1

select @assemid = assem_id, @modelid = sap_model_no from assemblies where psc_serial = @pscserial

if @assemid is null
begin
    select @lociacsserial = acs_serial, @model =sap_model from [ACSEEState].[dbo].loci where   [ACSEEState].[dbo].loci.psc_serial = @pscserial
    if @lociacsserial is not null
    begin
        set @acsserial = @lociacsserial

    end
    else
    begin
      set @acsserial = @pscserial
       select @model = sap_model from testlog where acs_serial = @acsserial
    end
end
else
begin
    select @acsserial = acs_serial from assemblies where assem_id = @assemid
    select @model = sap_model_name from products where sap_count = @modelid
end
print @acsserial

if @checkforpassingrecord =1
begin
if @acsserial is not null
   begin

         if substring(@model,1,2)='74' or substring(@model,1,1)='5' 
             begin
                exec ame_TFFC_ConfirmSpecific_TestedNew_NoResult @acsserial , @model, @model , @confirmstation  OUTPUT, @confirmpassfail  OUTPUT, @confrimOK  OUTPUT
--select @confirmpassfail
--print @confirmpassfail
                  if rtrim(@confirmpassfail)='P'
                    begin
                       set @passed = 1
                    end
                 else
                     begin
                         set @passed=0
                     end                 
	end

             else
             begin
	   if exists (select TL_ID from testlog where acs_serial = @acsserial )
	   begin
		select @passfailresult = pass_fail from testlog where acs_serial = @acsserial
		and test_date_time = (select max(test_date_time) from testlog where acs_serial = @acsserial )
                           
                           if @passfailresult = 'P'
                           begin
                                 set @passed = 1
                           end
                           else
                           begin
                                  set @passed = 0
                           end
	      end
	      else
  	      begin
                       if exists ( select TL_ID from testlog where acs_serial = @pscserial )
                       begin
                           select @passfailresult = pass_fail from testlog where acs_serial = @pscserial
                           and test_date_time = ( select max(test_date_time) from testlog where acs_serial = @pscserial)
                           if @passfailresult = 'P'
                           begin
                              set @passed = 1
                           end
                           else
                            begin
                                 set @passed = 0
                            end
                       end
                       else
                       begin
		set @passed = -1
                       end
	   end
             end
   end
   else
   begin
        set @passed = -1
   end

end

select @acsserial, @model, @passed
GO