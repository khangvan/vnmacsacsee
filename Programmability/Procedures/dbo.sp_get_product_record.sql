SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO



create proc [dbo].[sp_get_product_record]
-- Define input parameters
	@sname 		char(20) = NULL

-- Define code
AS
	--Verify that non-NULLable parameter(s) have values
	if @sname is NULL
	   begin
		raiserror ('E210.1 Illegal Parameter Value. You must specify a Model Number.',
			16,1) with nowait
		return
	   end

	--See if Model exists
	if not exists(select Status from Products 
		where SAP_Model_Name=@sname)
	   begin
		raiserror ('E210.2 Illegal Parameter Value. Model %s does not exist.',
			16,1,@sname) with nowait
		return
	   end

	-- Get Model information
	select Format_Name,Status from Products
	where SAP_Model_Name=@sname
	if @@ERROR <>0
	   begin
		raiserror('E210.3 Undefined error. Unable to retrieve Products db data.',17,1)
		return
	   end

-- Create the Stored Procedure


GO