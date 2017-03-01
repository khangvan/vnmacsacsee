SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_AddLimitModel_Note]
@station char(20),
@model char(20),
@note varchar(2000),
@retcode int OUTPUT
 AS
set nocount on


declare @logid int
declare @lastdate datetime
declare @sid int


set @retcode = 0


insert into ModelLimitHistory
(
MLH_Note,
MLH_StartDate,
MLH_EndDate
)
values
(
@note,
getdate(),
getdate()
)

               set @sid = scope_identity()
                if @sid is not null
                begin
                    update subtestlimits set Note_ID = @sid
                    where station_name = @station and SAP_Model_Name = @model 
                end
if @@ERROR <>0
begin
  set @retcode = 1
end
GO