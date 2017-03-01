SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_huy_focus]
	@dt smalldatetime = NULL
AS
	set nocount on

	exec sp_huy_seq0
	exec sp_huy_seq2 @dt
	exec sp_huy_seq9



GO