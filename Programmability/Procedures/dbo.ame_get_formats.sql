SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_get_formats]
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

	--See if  dbo.Loci exists
	if not exists(select SAP_Model from dbo.Formats WITH (NOLOCK)
		where SAP_Model = @sapmodel )
	   begin
		select 'NA'
		return
	   end
	select 'OK'
	select SAP_Model,Label_Format_Prefix,Type_Byte from dbo.Formats WITH (NOLOCK) 
		where SAP_Model = @sapmodel

-- Create the Stored Procedure
GO