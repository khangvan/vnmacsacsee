SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE PROCEDURE [dbo].[NewInsertCommand]
(
	@Action_Count smallint,
	@Description nchar(40)
)
AS
	SET NOCOUNT OFF;
INSERT INTO Actions(Action_Count, Description) VALUES (@Action_Count, @Description);
	SELECT Action_Count, Description FROM Actions WHERE (Action_Count = @Action_Count)
GO