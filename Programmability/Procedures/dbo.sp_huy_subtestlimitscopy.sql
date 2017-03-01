SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  PROCEDURE [dbo].[sp_huy_subtestlimitscopy]
	@SourceModel nvarchar(30),
	@DestinationModel nvarchar(30)
AS
	set nocount on

	if not exists (select top 1 * from subtestlimits where sap_model_name=@DestinationModel)
	begin
		insert into subtestlimits
		(Station_Name, SubTest_Name, SAP_Model_Name, Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, Author, ACSEEMode, SPCParm, Hard_UL, Hard_LL, Limit_Date, ProductGroup_Mask, Note_ID, OpportunitiesforFail)
		select Station_Name, SubTest_Name, 
		replace(SAP_Model_Name, SAP_Model_Name, @DestinationModel),
		Limit_Type, UL, LL, strLimit, flgLimit, Units, Description, 
		replace(Author, Author, 'DL\hqnguyen'),
		ACSEEMode, SPCParm, Hard_UL, Hard_LL, 
		replace(Limit_Date, Limit_Date, getdate()),
		ProductGroup_Mask, Note_ID, OpportunitiesforFail
		from subtestlimits
		where sap_model_name = @SourceModel
	end
		select * from subtestlimits where sap_model_name=@DestinationModel
GO