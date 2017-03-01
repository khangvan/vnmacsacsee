SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[NewDeleteCommand]
(
	@Original_Action_Count smallint,
	@Original_Description nchar(40)
)
AS
	SET NOCOUNT OFF;
DELETE FROM Actions WHERE (Action_Count = @Original_Action_Count) AND (Description = @Original_Description OR @Original_Description IS NULL AND Description IS NULL)
GO