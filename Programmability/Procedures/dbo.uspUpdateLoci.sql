SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspUpdateLoci]
(
	@ACS_Serial nchar(20),
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
	@Station char(20) = NULL,
	@Original_ACS_Serial nchar(20) = NULL,
	@Original_Assembly_ACSSN nchar(20) = NULL,
	@Original_Last_Event_Date datetime = NULL,
	@Original_LineByte int = NULL,
	@Original_Next_Station_Name nchar(20) = NULL,
	@Original_ORT_Bin nchar(5) = NULL,
	@Original_ORT_Start nchar(20) = NULL,
	@Original_ORT_Status nchar(5) = NULL,
	@Original_PSC_Serial nchar(20) = NULL,
	@Original_PlantByte int = NULL,
	@Original_SAP_Model nchar(20) = NULL,
	@Original_SieveByte int = NULL,
	@Original_Station char(20) = NULL,
	@Original_Test_ID char(50) = NULL,
	@Original_UnitStnByte int = NULL
)
AS
	SET NOCOUNT ON;
UPDATE Loci SET ACS_Serial = @ACS_Serial, ORT_Status = @ORT_Status, ORT_Bin = @ORT_Bin, ORT_Start = @ORT_Start, PSC_Serial = @PSC_Serial, Assembly_ACSSN = @Assembly_ACSSN, SAP_Model = @SAP_Model, SieveByte = @SieveByte, UnitStnByte = @UnitStnByte, LineByte = @LineByte, PlantByte = @PlantByte, Next_Station_Name = @Next_Station_Name, Last_Event_Date = @Last_Event_Date, Test_ID = @Test_ID, Station = @Station WHERE (ACS_Serial = @Original_ACS_Serial) AND (Assembly_ACSSN = @Original_Assembly_ACSSN OR @Original_Assembly_ACSSN IS NULL AND Assembly_ACSSN IS NULL) AND (Last_Event_Date = @Original_Last_Event_Date OR @Original_Last_Event_Date IS NULL AND Last_Event_Date IS NULL) AND (LineByte = @Original_LineByte OR @Original_LineByte IS NULL AND LineByte IS NULL) AND (Next_Station_Name = @Original_Next_Station_Name OR @Original_Next_Station_Name IS NULL AND Next_Station_Name IS NULL) AND (ORT_Bin = @Original_ORT_Bin OR @Original_ORT_Bin IS NULL AND ORT_Bin IS NULL) AND (ORT_Start = @Original_ORT_Start OR @Original_ORT_Start IS NULL AND ORT_Start IS NULL) AND (ORT_Status = @Original_ORT_Status OR @Original_ORT_Status IS NULL AND ORT_Status IS NULL) AND (PSC_Serial = @Original_PSC_Serial OR @Original_PSC_Serial IS NULL AND PSC_Serial IS NULL) AND (PlantByte = @Original_PlantByte OR @Original_PlantByte IS NULL AND PlantByte IS NULL) AND (SAP_Model = @Original_SAP_Model OR @Original_SAP_Model IS NULL AND SAP_Model IS NULL) AND (SieveByte = @Original_SieveByte OR @Original_SieveByte IS NULL AND SieveByte IS NULL) AND (Station = @Original_Station OR @Original_Station IS NULL AND Station IS NULL) AND (Test_ID = @Original_Test_ID OR @Original_Test_ID IS NULL AND Test_ID IS NULL) AND (UnitStnByte = @Original_UnitStnByte OR @Original_UnitStnByte IS NULL AND UnitStnByte IS NULL);
	SELECT ACS_Serial, ORT_Status, ORT_Bin, ORT_Start, PSC_Serial, Assembly_ACSSN, SAP_Model, SieveByte, UnitStnByte, LineByte, PlantByte, Next_Station_Name, Last_Event_Date, Test_ID, Station FROM Loci WHERE (ACS_Serial = @ACS_Serial)
GO