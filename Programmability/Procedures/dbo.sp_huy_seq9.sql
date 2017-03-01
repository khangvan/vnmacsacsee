SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_huy_seq9]
	
AS
	set nocount on

	select * from tmpFPY
	select Station,SubTest_Name as SubTest_Name1, count(*) as Total from tmpFailure1
	group by Station,SubTest_Name

	drop table tmpFailure
	drop table tmpFailure1
	drop table tmpFPY

GO