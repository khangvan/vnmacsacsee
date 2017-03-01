SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_write_Assemblies]
@ACS_Serial char(20), 
@SAP_Model char(20), 
@Start_Station char(20), 
@Top_Model_Prfx char(5), 
@Start_Mfg datetime, 
@PSC_Serial char(20), 
@End_Mfg datetime, 
@Sales_Order char(10), 
@Line_Item char(6), 
@Current_State char(1)
 AS
declare @sap_model_no int
declare @start_station_no int


if not exists ( select acs_serial from assemblies where acs_serial = @ACS_Serial )
begin
   if not exists ( select psc_serial from assemblies where psc_serial=@PSC_Serial)
   begin

      select @sap_model_no = sap_model_no from assemblies 
                     inner join products on sap_model_no = sap_count where sap_model_name = @SAP_Model 
      
       select @start_station_no = station_count from stations where station_name = @Start_Station

        insert into assemblies
        (
        ACS_Serial, 
        SAP_Model_No, 
        Start_Station, 
        Top_Model_Prfx, 
         Start_Mfg, 
         PSC_Serial, 
         End_Mfg, 
         Sales_Order, 
          Line_Item, 
          Current_State
        )
        values
        (
          @ACS_Serial,
          @sap_model_no,
          @start_station_no,
          @Top_Model_Prfx,
          @Start_mfg,
          @PSC_Serial,
           @End_Mfg,
           @Sales_Order,
           @Line_Item,
           @Current_State
        )
      
   end
end
GO