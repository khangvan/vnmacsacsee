SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_BASCULA_CheckForTTonReWork]
@acsserial char(20),
@station char(20)
 AS

declare @tlid int
declare @maxtlid int
declare @repairaction int
declare @causecategory int
declare @origincode int
declare @fruid int
declare @type int
declare @logdate datetime
declare @modifieddate datetime
declare @istouched tinyint

set nocount on

if ( @acsserial in ('SE000167399','SE000167400','SE000167398'))
begin
select 'OK'
end
else
begin

if exists ( select  max(TL_ID) from testlog where acs_serial = @acsserial and substring(station,1,len(station) -1)= substring(@station,1,len(@station)-1)  )
   begin
     select @maxtlid = max(TL_ID) from testlog where acs_serial = @acsserial and substring(station,1,len(station)-1)= substring(@station,1,len(@station)-1) 
    if exists   (  select max(TL_ID) from testlog where acs_serial = @acsserial and substring(station,1,len(station)-1)= substring(@station,1,len(@station)-1) and pass_fail = 'F')
    begin 
       select @tlid = max(TL_ID) from testlog where acs_serial = @acsserial and substring(station,1,len(station)-1)= substring(@station,1,len(@station)-1) and pass_fail = 'F'
print 'tlid'
print @tlid
print 'maxtlid'
print @maxtlid
     if @tlid = @maxtlid
      begin
           select @istouched = FLG_Touched  from rawfrufailurelog where FLG_TL_ID = @tlid
           if @istouched = 0
            begin
                   select 'NOT MODIFIED'
            end
            else
            begin
                   select 'OK'
            end
      end
     else
      begin
        select 'OK'
      end
   end
   end
else
   begin
   select 'OK'
   end

end
GO