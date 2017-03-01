SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_huy_seq0]
	
AS
	set nocount on

	create table tmpFailure (
		ACS_Serial char(30),
		SubTest_Name char(30),
		strValue char(30),
		Station char(30),
		TID int
	)
	create table tmpFailure1 (
		Station char(30),
		ACS_Serial char(30),
		SubTest_Name char(30),
		strValue char(30)
	)

	create table tmpFPY (
		Station char(30),
		Total int,
		Pass int,
		RPass int,
		FromDate char(19)
	)

GO