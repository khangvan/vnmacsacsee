SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

create proc [dbo].[Fill_Yield_PCB]
as
declare @S char(30)
declare @B char(30)
declare @P char(20)
declare @T int
declare @E int
declare @C datetime
declare @F datetime
declare @a char(50)
declare @z char(4)
set @z = 'INFO'
set @C = dateadd(day,-1,getdate())
set @F = convert(datetime,
	convert(char(2),datepart(m,@C))+'/'+convert(char(2),datepart(d,@C))+'/'
	+convert(char(4),datepart(yyyy,@C)))
set @C = @F
set @S = 'ViperAnalog1'
set @B = '3-0437-02'

select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @S = 'MambaAnalog1'
set @B = '3-0473-02'

select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin 
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0474-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @S = 'ViperProgramming1'
set @B = '3-0439-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0439-04'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0439-06'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0483-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z
     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0483-04'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z

     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @S = 'ViperInterface1'
set @B = '3-0483-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z
     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @B = '3-0483-04'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z
     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @S = 'ViperDigital1'
set @B = '3-0439-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z
     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end
set @S = 'MambaProgramming1'
set @B = '3-0490-02'
select @a = Description from BOM where SAP_Model=@B and Part_Number=@z
     exec PCB @S,@B,@C,
	@P OUT, @T OUT, @E OUT
     if @T>0
	begin
     	   insert Yield_PCB
     	   values(@C,@S,@B,@P,@T,@E,@a)
	end

GO