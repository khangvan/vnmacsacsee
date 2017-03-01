SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[NewUpdateCommand]
(
	@Action_Count smallint,
	@Description nchar(40),
	@Original_Action_Count smallint,
	@Original_Description nchar(40)
)
AS
	SET NOCOUNT OFF;
UPDATE Actions SET Action_Count = @Action_Count, Description = @Description WHERE (Action_Count = @Original_Action_Count) AND (Description = @Original_Description OR @Original_Description IS NULL AND Description IS NULL);
	SELECT Action_Count, Description FROM Actions WHERE (Action_Count = @Action_Count)
GO