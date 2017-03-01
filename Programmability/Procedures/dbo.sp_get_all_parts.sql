SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_all_parts]

-- Define code
AS
	Select Part_No_Name, Description, Status from Catalog
	order by Part_No_Name
	if @@ERROR <>0
	   begin
		raiserror('E109.1 Undefined error. Unable to retrieve Catalog db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO