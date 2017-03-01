SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[uspDeleteLociASM]
(
	@Original_ACS_Serial nchar(20),
	@Original_Assembly_ACSSN nchar(20),
	@Original_Last_Event_Date datetime,
	@Original_LineByte int,
	@Original_Next_Station_Name nchar(20),
	@Original_ORT_Bin nchar(5),
	@Original_ORT_Start nchar(20),
	@Original_ORT_Status nchar(5),
	@Original_PSC_Serial nchar(20),
	@Original_PlantByte int,
	@Original_SAP_Model nchar(20),
	@Original_SieveByte int,
	@Original_Station char(20),
	@Original_Test_ID char(50),
	@Original_UnitStnByte int
)
AS
	SET NOCOUNT OFF;
DELETE FROM Loci WHERE (ACS_Serial = @Original_ACS_Serial) AND (Assembly_ACSSN = @Original_Assembly_ACSSN OR @Original_Assembly_ACSSN IS NULL AND Assembly_ACSSN IS NULL) AND (Last_Event_Date = @Original_Last_Event_Date OR @Original_Last_Event_Date IS NULL AND Last_Event_Date IS NULL) AND (LineByte = @Original_LineByte OR @Original_LineByte IS NULL AND LineByte IS NULL) AND (Next_Station_Name = @Original_Next_Station_Name OR @Original_Next_Station_Name IS NULL AND Next_Station_Name IS NULL) AND (ORT_Bin = @Original_ORT_Bin OR @Original_ORT_Bin IS NULL AND ORT_Bin IS NULL) AND (ORT_Start = @Original_ORT_Start OR @Original_ORT_Start IS NULL AND ORT_Start IS NULL) AND (ORT_Status = @Original_ORT_Status OR @Original_ORT_Status IS NULL AND ORT_Status IS NULL) AND (PSC_Serial = @Original_PSC_Serial OR @Original_PSC_Serial IS NULL AND PSC_Serial IS NULL) AND (PlantByte = @Original_PlantByte OR @Original_PlantByte IS NULL AND PlantByte IS NULL) AND (SAP_Model = @Original_SAP_Model OR @Original_SAP_Model IS NULL AND SAP_Model IS NULL) AND (SieveByte = @Original_SieveByte OR @Original_SieveByte IS NULL AND SieveByte IS NULL) AND (Station = @Original_Station OR @Original_Station IS NULL AND Station IS NULL) AND (Test_ID = @Original_Test_ID OR @Original_Test_ID IS NULL AND Test_ID IS NULL) AND (UnitStnByte = @Original_UnitStnByte OR @Original_UnitStnByte IS NULL AND UnitStnByte IS NULL)
GO