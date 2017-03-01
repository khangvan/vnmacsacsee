SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[user_get_BBModel]
	@PCBA char(30) = NULL

AS
	set nocount on
	
	declare @result char(20)
	declare @result1 char(20)

	declare @sub char(20)
	declare @base char(20)
	declare @mac char(20)
	declare @pcba_id int

	select @sub=acs_serial from asylog
	where scanned_serial=ltrim(rtrim(@PCBA))
	
	if (@sub is null)
	begin
		set @result='NG'
	end
	else
	begin
		select @base=acs_serial from asylog
		where scanned_serial=ltrim(rtrim(@sub))
	end

	if (@base is null)
	begin
		set @result='NG'
	end
	else
	begin
		set @result=ltrim(rtrim(@base))
	end

	select @pcba_id=assem_id from assemblies
	where acs_serial=ltrim(rtrim(@PCBA))

	if (@pcba_id is null)
	begin
		set @result1='NG'
	end
	else
	begin
		select @mac=asp_value from assemblyparameters
		where asp_assem_id=@pcba_id
	end

	if (@mac is null)
	begin
		set @result1='NG'
	end
	else
	begin
		set @result1=ltrim(rtrim(@mac))
	end

	select @result as Result, @result1 as Result1
	return
GO