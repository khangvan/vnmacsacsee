SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_modify_newstation]
@scount int,
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
	@Water	char(20)='ENGACSDB',
	@App		char(20)='ACSEEAPP1',
	@Bus		char(20)='ENGACSDB'


AS
--declare @maxstn int

--select @maxstn=last_value from counters where counter_code=3

--set @maxstn = @maxstn + 1

--update counters
--set last_value=@maxstn
--where counter_code=3

--select @maxstn


update stations
set Station_Name =@sname,
 Description = @desc,
ACS_Serial_ID = @acsserial,
Gen_PSC_Serial = @genpsc,
Print_Asm_Label=@asmprint,
Print_Unit_Label = @unitprint,
Print_Carton_Label=@cartonprint,
Print_Extra_Label=@extraprint,
Allow_Overrides=@overrides,
Finish_Assembly=@fin,
Perform_Test=@test,
Assign_Sales_Order=@assign,
Backflush=@back,
Status=@status,
Machine_Name=@machine,
FactoryGroup_Mask = @factory,
ProductGroup_Mask=@product,
Order_Value=@order,
Thin_Client=@thin,
Station_Type=@stype,
Waterfall_Server_Machine_Name=@water,
Application_Server_Machine_Name=@app,
Business_Server_Machine_Name=@bus,
STN_MfgLine_ID=@line
where station_count = @scount



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