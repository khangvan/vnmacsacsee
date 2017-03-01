SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO

CREATE PROCEDURE [dbo].[uspSubTestList]
	(
	@UserName_1	varchar(25)
	)
AS
SET NOCOUNT ON
IF (@UserName_1 = 'jmmcconnell') OR (@UserName_1 = 'dasustai')
	SELECT     TOP 100 PERCENT Station_Name, SubTest_Name, Limit_Type, [Description], Author
	FROM         dbo.SubTestLimits
	GROUP BY Station_Name, SubTest_Name, Limit_Type, [Description], Author
	ORDER BY Station_Name, SubTest_Name
ELSE
	SELECT     TOP 100 PERCENT Station_Name, SubTest_Name, Limit_Type, [Description], Author
	FROM         dbo.SubTestLimits
	GROUP BY Station_Name, SubTest_Name, Limit_Type, [Description], Author
	HAVING (Author = @UserName_1)
	ORDER BY Station_Name, SubTest_Name
GO