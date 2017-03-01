SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspDeleteSubTest]
	(
	@Station_Name_1	char(20),
	@SubTest_Name_2	char(20),
	@Limit_Type_3	char(1)
	)
AS
DELETE dbo.SubTestLimits
WHERE (Station_Name = @Station_Name_1) AND (SubTest_Name = @SubTest_Name_2) AND (Limit_Type = @Limit_Type_3)
GO