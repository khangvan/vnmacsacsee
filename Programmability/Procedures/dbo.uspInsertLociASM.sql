SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspInsertLociASM]
(
	@ACS_Serial nchar(20),
	@ORT_Status nchar(5),
	@ORT_Bin nchar(5),
	@ORT_Start nchar(20),
	@PSC_Serial nchar(20),
	@Assembly_ACSSN nchar(20),
	@SAP_Model nchar(20),
	@SieveByte int,
	@UnitStnByte int,
	@LineByte int,
	@PlantByte int,
	@Next_Station_Name nchar(20),
	@Last_Event_Date datetime,
	@Test_ID char(50),
	@Station char(20)
)
AS
	SET NOCOUNT OFF;
INSERT INTO Loci(ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station) VALUES (@ACS_Serial, @ORT_Status, @ORT_Bin, @ORT_Start, @PSC_Serial, @Assembly_ACSSN, @SAP_Model, @SieveByte, @UnitStnByte, @LineByte, @PlantByte, @Next_Station_Name, @Last_Event_Date, @Test_ID, @Station);
	SELECT ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station FROM Loci WHERE (ACS_Serial = @ACS_Serial)
GO