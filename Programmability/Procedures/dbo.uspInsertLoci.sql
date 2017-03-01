SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspInsertLoci]
(
	@ACS_Serial nchar(20) = NULL,
	@ORT_Status nchar(5) = NULL,
	@ORT_Bin nchar(5) = NULL,
	@ORT_Start nchar(20) = NULL,
	@PSC_Serial nchar(20) = NULL,
	@Assembly_ACSSN nchar(20) = NULL,
	@SAP_Model nchar(20) = NULL,
	@SieveByte int = NULL,
	@UnitStnByte int = NULL,
	@LineByte int = NULL,
	@PlantByte int = NULL,
	@Next_Station_Name nchar(20) = NULL,
	@Last_Event_Date datetime = NULL,
	@Test_ID char(50) = NULL,
	@Station char(20) = NULL
)
AS
	SET NOCOUNT ON;
INSERT INTO Loci(ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station) VALUES (@ACS_Serial, @ORT_Status, @ORT_Bin, @ORT_Start, @PSC_Serial, @Assembly_ACSSN, @SAP_Model, @SieveByte, @UnitStnByte, @LineByte, @PlantByte, @Next_Station_Name, @Last_Event_Date, @Test_ID, @Station);
	SELECT ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station FROM Loci WHERE (ACS_Serial = @ACS_Serial)
GO