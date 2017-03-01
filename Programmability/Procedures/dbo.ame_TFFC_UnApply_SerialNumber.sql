SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_TFFC_UnApply_SerialNumber]
@acsserial char(20),
@OK char(20) OUTPUT
 AS
set nocount on

declare @checkforserialinorder int
declare @reserved char(20)

declare @strLog1 char(512)


begin transaction
select @checkforserialinorder = TFFC_ID from tffc_serialnumbers  WITH (TABLOCKX)  where TFFC_Reservedby = rtrim(@acsserial)


        set @strLog1 = 'unapply1 pid=' + convert(varchar, @@SPID) + '  acsserial=[' + isnull(@acsserial,'') +']   '


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

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


if @checkforserialinorder is not null
begin
   select @reserved = TFFC_ReservedBy from TFFC_Serialnumbers where TFFC_ID = @checkforserialinorder
   if @reserved is not null
   begin
         if len(rtrim(@reserved)) > 0 
         begin
                   update TFFC_SerialNumbers set TFFC_Reserved = 0,tffc_consumed=0, TFFC_Reservedby = '' where TFFC_ID = @checkforserialinorder



        set @strLog1 = 'unapply2 pid=' + convert(varchar, @@SPID) + '  acsserial=[' + isnull(@acsserial,'') +']   tffcID=[' + convert(varchar,isnull(@checkforserialinorder,0)) +']'


--set @strLog = "consume1 pid=" + @@SPID + " prodorder=[" + @ProdOrder +"]  acsserial=[" + @acsserial +"] usedserial=["+ @usedserial +"]   tffcID=[" + @tffcID +"]"

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



                   set @OK ='OK'
          end
          else
          begin
             set @OK = 'BAD'
          end
   end
   else
   begin
      set @OK='BAD'
   end
end
else
begin
set @OK = 'Serial not found'
end
commit transaction
select @OK as ok
GO