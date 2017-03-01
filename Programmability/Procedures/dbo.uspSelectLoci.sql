SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspSelectLoci]
(
	@acssn_1 nchar(20)
)
AS
	SET NOCOUNT ON;
SELECT ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station FROM Loci WHERE (ACS_Serial = @acssn_1)
GO