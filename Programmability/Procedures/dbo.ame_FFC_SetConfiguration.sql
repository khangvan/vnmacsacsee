SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_SetConfiguration] 
@FFC_NextRunDateTime datetime,
@FFC_DSO tinyint, 
@FFC_DLimits tinyint, 
@FFC_DBOMs tinyint, 
@FFC_DFiles tinyint, 
@FFC_UStatus tinyint, 
@FFC_UAssembly tinyint, 
@FFC_UTestlog tinyint, 
@FFC_LastRunDate datetime,
@FFC_AdminSchedule int, 
@FFC_Recur_Occurs int, 
@FFC_Daily_Days int, 
@FFC_Monthly_Day int, 
@FFC_Monthly_Month int, 
@FFC_Weekly_Freq int, 
@FFC_Mon tinyint, 
@FFC_tue tinyint, 
@FFC_wed tinyint, 
@FFC_Thur  tinyint, 
@FFC_Fri tinyint, 
@FFC_Sat tinyint, 
@FFC_Sun tinyint, 
@FFC_DailyFreq int, 
@FFC_DailyFreq_Time datetime, 
@FFC_DailyFreq_Interval int, 
@FFC_StartDate datetime, 
@FFC_Ending int, 
@FFC_EndDateTime datetime,
@FFC_OneTimeDateTime datetime

AS
set nocount on
update FFC_Configuration 
set FFC_NextRunDateTime =@FFC_NextRunDateTime,
FFC_DSO = @FFC_DSO,
FFC_DLimits = @FFC_DLimits,
FFC_DBOMs = @FFC_DBOMs,
FFC_DFiles = @FFC_DFiles,
FFC_UStatus = @FFC_UStatus,
FFC_UAssembly = @FFC_UAssembly,
FFC_UTestlog = @FFC_UTestlog,
FFC_LastRunDate = @FFC_LastRunDate,
FFC_AdminSchedule = @FFC_AdminSchedule,
FFC_Recur_Occurs= @FFC_Recur_Occurs,
FFC_Daily_Days = @FFC_Daily_Days,
FFC_Monthly_Day = @FFC_Monthly_Day,
FFC_Monthly_Month = @FFC_Monthly_Month,
FFC_Weekly_Freq=@FFC_Weekly_Freq,
FFC_Mon = @FFC_Mon,
FFC_Tue = @FFC_Tue,
FFC_Wed = @FFC_Wed,
FFC_Thur=@FFC_Thur,
FFC_Fri=@FFC_Fri,
FFC_Sat=@FFC_Sat,
FFC_Sun=@FFC_Sun,
FFC_DailyFreq=@FFC_DailyFreq,
FFC_DailyFreq_Time = @FFC_DailyFreq_Time,
FFC_DailyFreq_Interval=@FFC_DailyFreq_Interval,
FFC_StartDate=@FFC_StartDate,
FFC_Ending=@FFC_Ending,
FFC_EndDateTime=@FFC_EndDateTime,
FFC_OneTimeDateTime=@FFC_OneTimeDateTime


select * from FFC_Configuration
GO