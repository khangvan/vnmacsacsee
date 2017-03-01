SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
CREATE proc [dbo].[ame_XML_BOM]
-- Define input parameters
	@xdoc		varchar(8000) = NULL -- xdoc
	
-- Define code
AS
	declare @idoc int
	declare @tdate datetime
	set @tdate = getdate()

	exec sp_xml_preparedocument @idoc OUTPUT, @xdoc

	insert into ZBOM01
	select (1) as MATNR, (2) as IDNRK, (3) as REVLV, (4) as MEINS, (5) as MENGE, 
		(5) as DATUV, (6) as DATIB, (7) as EBORT, (8) as MAKTX, (9) as STUFE from OPENXML (@idoc,'/ROOT/ZBOM01')
	exec sp_xml_removedocument @idoc
GO