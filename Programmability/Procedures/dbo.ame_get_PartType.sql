SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
create proc [dbo].[ame_get_PartType]

As
	SELECT Result_Digits, Description_Parse_Value, Check_Order FROM PARTTYPE ORDER BY CHECK_ORDER
GO