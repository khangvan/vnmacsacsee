﻿SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LogSuccess] 
@Step varchar(80),
@startstop int,
@src varchar(150),
@StepNotes char(80),
@Parameter1 varchar(50),
@Parameter2 varchar(50),
@Parameter3 varchar(50),
@Documentation varchar(255),
@Owner char(40)
AS

declare @starttime datetime
declare @endtime datetime
declare @Status char(20)

set @Status = 'Success'
if @startstop = 0 
begin
   set @starttime = NULL
   set @endtime = GetDate()
end
else
begin
   set @starttime = GetDate()
   set @endtime = NULL
end

insert into TRN_ImportLog
(
JOB_DateTime,
JOB_Step,
JOB_Status,
JOB_StepNotes,
JOB_Parameter1,
JOB_Parameter2,
JOB_Parameter3,
JOB_Completion,
JOB_Source,
JOB_Documentation,
JOB_Owner
)
values
(
@starttime,
@Step,
@Status,
@StepNotes,
@Parameter1,
@Parameter2,
@Parameter3,
@endtime,
@src,
@Documentation,
@Owner
)
GO