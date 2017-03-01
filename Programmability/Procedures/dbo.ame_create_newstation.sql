SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_create_newstation]
@sname char(20),
              @line                 int,
	@desc 		nchar(40) = NULL, -- Description
	@acsserial 	char(2) = NULL,	 -- ACS_Serial_ID
	@genpsc 	char(1) = NULL, -- Gen_PSC_Serial
	@asmprint 	char(1) = NULL,	 -- Print_Asm_Label
	@unitprint	char(1) = NULL,	-- Print_Unit_Label
	@cartonprint	char(1) = NULL,	 -- Print_Carton_Label
	@extraprint	char(1) = NULL,	-- Print_Extra_Label
	@overrides	char(1) = NULL,	 -- Allow_Overrides
	@fin		char(1) = NULL,	-- Finish_Assembly 
	@test		char(1) = NULL, -- Perform_Test
 	@assign		char(1) = NULL, -- Assign_Sales_Order
	@back		char(1) = NULL,	-- Backflush (keep as NULL, included for future development) 
	@status		char(1) = 'A', -- Status
	@machine	char(30) = NULL, -- Machine Name (from the station's registry)
	@factory	int = 1,
	@Product	int = 1,
	@Order		int = 0,
	@Thin		char(1)='Y',
	@stype		char(3)='ACS',
	@Water	char(20)='ACSEEDB1',
	@App		char(20)='ACSEEAPP1',
	@Bus		char(20)='ACSEEDEV'


AS
declare @maxstn int


if not exists ( select station_count  from stations where Station_Name = @sname )
begin
select @maxstn=last_value from counters where counter_code=3

set @maxstn = @maxstn + 1

if @test is null 
begin
set @test ='Y'
end

update counters
set last_value=@maxstn
where counter_code=3

select @maxstn


insert into stations
(
Station_Count,
Station_Name,
Description,
ACS_Serial_ID,
Gen_PSC_Serial,
Print_Asm_Label,
Print_Unit_Label,
Print_Carton_Label,
Print_Extra_Label,
Allow_Overrides,
Finish_Assembly,
Perform_Test,
Assign_Sales_Order,
Backflush,
Status,
Machine_Name,
FactoryGroup_Mask,
ProductGroup_Mask,
Order_Value,
Thin_Client,
Station_Type,
Waterfall_Server_Machine_Name,
Application_Server_Machine_Name,
Business_Server_Machine_Name,
STN_MfgLine_ID,
SAPLocationIndex
)
values
(
@maxstn,
@sname,
	@desc, -- Description
	@acsserial,	 -- ACS_Serial_ID
	@genpsc, -- Gen_PSC_Serial
	@asmprint,	 -- Print_Asm_Label
	@unitprint,	-- Print_Unit_Label
	@cartonprint,	 -- Print_Carton_Label
	@extraprint,	-- Print_Extra_Label
	@overrides,	 -- Allow_Overrides
	@fin,	-- Finish_Assembly 
	@test, -- Perform_Test
 	@assign, -- Assign_Sales_Order
	@back,	-- Backflush (keep as NULL, included for future development) 
	@status, -- Status
	@machine, -- Machine Name (from the station's registry)
	@factory,
	@Product,
	@Order	,
	@Thin,
	@stype,
	@Water,
	@App,
	@Bus,
              @line,
              0

)

end

select
Station_Count,
Station_Name,
Description,
ACS_Serial_ID,
Gen_PSC_Serial,
Print_Asm_Label,
Print_Unit_Label,
Print_Carton_Label,
Print_Extra_Label,
Allow_Overrides,
Finish_Assembly,
Perform_Test,
Assign_Sales_Order,
Backflush,
Status,
Machine_Name,
FactoryGroup_Mask,
ProductGroup_Mask,
Order_Value,
Thin_Client,
Station_Type,
Waterfall_Server_Machine_Name,
Application_Server_Machine_Name,
Business_Server_Machine_Name,
STN_MfgLine_ID
from stations where station_name = @sname
GO