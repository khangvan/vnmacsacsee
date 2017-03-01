SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_NACS_UpdatePrintFileItem]
@id int,
@PrintFileName char(20),
@DoPrint char(3),
@BulkPrint int,
@Ribbon char(50),
@Paper char(50),
@Machine char(50),
@User  char(50)

 AS
set nocount on


update NACS_PrintFileLookup
set PRF_PrintFileName = @PrintFileName, PRF_DoPrint =@DoPrint, PRF_BulkPrintFile=@BulkPrint, PRF_Ribbon=@Ribbon, PRF_Paper=@Paper, PRF_Machine=@Machine, PRF_User=@User
where PRF_ID = @id



GO