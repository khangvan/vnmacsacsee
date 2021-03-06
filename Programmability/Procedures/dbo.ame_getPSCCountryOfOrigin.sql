﻿SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_getPSCCountryOfOrigin]
@pscserial char(20),
@sapmodel char(20)
 AS
declare @countryoforigin char(50)
declare @scannedserial char(50)
declare @partname char(20)
declare @firsttwoscanned char(3)
declare @counter int
declare @acsserial char(20)
--select @scannedserial = scanned_serial from asylog where acs_serial = @acsserial


select @acsserial = acs_serial from [ACSEEState].[dbo].loci where psc_serial = @pscserial

declare cur_parts CURSOR static for
       select part_no_name, scanned_serial from asylog inner join catalog on added_part_no = part_no_count where acs_serial = @acsserial
       and len(scanned_serial) > 0 order by action_date

set @countryoforigin = 'PRODUCT OF USA'
set @counter = 0
--print @counter

open cur_parts
FETCH NEXT from cur_parts into @partname, @scannedserial
WHILE @@FETCH_STATUS = 0
begin
set @counter = @counter + 1
--print @counter

if   substring(@scannedserial,1,2) = 'PX'
  begin                          
                                if substring(@sapmodel,1,3) = 'MG1' and substring(@partname,1,2)='5-' 
                                   begin
                                        set @countryoforigin =        'MADE IN MALAYSIA'
                                    end
   end                          
if    substring(@scannedserial,1,2) = 'BK' 
         begin
                               if substring(@partname,1,2) = 'PS' OR substring(@partname,1,3)='061' OR substring(@partname,1,3) = '062' 
                                         begin
                                             set @countryoforigin = 'MADE IN SINGAPORE'
                                         end
        end

if    substring(@scannedserial,1,2) = 'BF' 
         begin
--                               if substring(@partname,1,2) = 'PS' OR substring(@partname,1,3)='061' OR substring(@partname,1,3) = '062' 
--                                             begin
                                                   set @countryoforigin = 'MADE IN SINGAPORE'
--                                              end
       end



if    substring(@scannedserial,1,2) = 'RP' 
         begin
                               if substring(@partname,1,3) = '780'  
                                          begin
                                             set @countryoforigin = 'MADE IN MALAYSIA'
                                           end
        end


if    substring(@scannedserial,1,2) = 'CP' 
         begin
                               if substring(@partname,1,3) = '770'  
                                         begin
                                             set @countryoforigin = 'MADE IN MALAYSIA'
                                         end
       end


if    substring(@scannedserial,1,2) = 'QS' 
         begin
                               if substring(@partname,1,3) = '105'  OR substring(@partname,1,3) = 'QS2'  
                                          begin
                                             set @countryoforigin = 'MADE IN TAIWAN'
                                           end
        end

if substring(@sapmodel,1,4) = 'QS25'
     begin
            if substring(@scannedserial,1,2) = 'QS'
                     begin
                               set @countryoforigin = 'MADE IN TAIWAN'
                     end
     end


if    substring(@scannedserial,1,2) = 'QW' 
         begin
                               if substring(@partname,1,3) = 'QS1' OR  substring(@partname,1,3) = '069'
                                          begin
                                             set @countryoforigin = 'MADE IN SINGAPORE'
                                           end
       end




if    substring(@scannedserial,1,2) = 'SS' 
         begin
                               if substring(@partname,1,3) = 'QS6' OR  substring(@partname,1,2) = '66' OR substring(@partname,1,3) ='5-1'
                                   begin
                                             set @countryoforigin = 'MADE IN SINGAPORE'
                                   end
       end


if    substring(@scannedserial,1,2) = 'SA' 
         begin
                               if substring(@partname,1,2) = 'SA' 
                                        begin
                                             set @countryoforigin = 'MADE IN SINGAPORE'
                                         end
       end



if    substring(@scannedserial,1,2) = 'V8' 
         begin
                               if substring(@partname,1,3) = '068'  OR  substring(@partname,1,3) = '5-1' OR  substring(@partname,1,1) = 'V'
                                         begin
                                             set @countryoforigin = 'MADE IN MALAYSIA'
                                         end
       end



FETCH NEXT from cur_parts into @partname, @scannedserial
end

close cur_parts
deallocate cur_parts


select @countryoforigin
GO