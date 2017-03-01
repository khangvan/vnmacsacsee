SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_FFC_GetConfiguration]
AS
set nocount on

select  FFC_NextRunDateTime, FFC_DSO, 
           FFC_DLimits, FFC_DBOMs, FFC_DFiles, FFC_UStatus, 
           FFC_UAssembly, FFC_UTestlog, FFC_LastRunDate,
           FFC_AdminSchedule, FFC_Recur_Occurs, FFC_Daily_Days, 
           FFC_Monthly_Day, FFC_Monthly_Month, FFC_Weekly_Freq, 
           FFC_Mon, FFC_tue, FFC_wed, FFC_Thur, FFC_Fri, FFC_Sat, FFC_Sun, 
           FFC_DailyFreq, FFC_DailyFreq_Time, FFC_DailyFreq_Interval, 
           FFC_StartDate, FFC_Ending, FFC_EndDateTIme,FFC_OneTimeDateTime
from
FFC_Configuration
GO