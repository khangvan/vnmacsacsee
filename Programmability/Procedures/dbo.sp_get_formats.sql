SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE proc [dbo].[sp_get_formats]
-- Define input parameters
	@sapmodel 	char(20) = NULL
	
-- Define code
AS
	set nocount on
	--Verify that non-NULLable parameter(s) have values
	if @sapmodel is NULL
	   begin
		select 'Error: You must specify an SAP Serial Number'
		return
	   end

	--See if Loci exists
	if not exists(select SAP_Model from Formats 
		where SAP_Model = @sapmodel )
	   begin
		select 'NA'
		return
	   end
	select 'OK'
	select * from Formats
		where SAP_Model = @sapmodel

-- Create the Stored Procedure
GO