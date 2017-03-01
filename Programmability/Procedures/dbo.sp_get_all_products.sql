SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_all_products]

-- Define code
AS
	Select SAP_Model_Name, Format_Name, Status from Products
	order by SAP_Model_Name
	if @@ERROR <>0
	   begin
		raiserror('E209.1 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO