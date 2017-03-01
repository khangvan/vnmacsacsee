SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE proc [dbo].[ame_lookup_assembly]
-- Define input parameters
	@pserial	char(20) = NULL, -- PSC_Serial
	@model		char(20)  OUTPUT, -- model number
	@found int    OUTPUT
	-- Define code
AS
	-- Local variables
	
	set @found = 1

             set @model = ' '

             if exists ( select sap_model_name from assemblies inner join products on sap_count = sap_model_no where psc_serial=@pserial )
             begin
                       set @found = 0 
                       select @model = sap_model_name  from assemblies inner join products on sap_count = sap_model_no where psc_serial=@pserial
             end

	

-- Create the Stored Procedure
GO