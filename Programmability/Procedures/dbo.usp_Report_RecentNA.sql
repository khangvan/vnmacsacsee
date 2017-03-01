SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO


CREATE  procedure [dbo].[usp_Report_RecentNA]
as
set nocount on
select  
	dbo.Loci.ACS_Serial, 
	dbo.LociLog.ORT_Status, 
	dbo.LociLog.ORT_Bin, 
	dbo.LociLog.ORT_Start, 
	dbo.LociLog.PSC_Serial, 
	dbo.LociLog.Assembly_ACSSN, 
	dbo.LociLog.SAP_Model, 
	dbo.LociLog.SieveByte, 
	dbo.LociLog.UnitStnByte, 
	dbo.LociLog.LineByte, 
	dbo.LociLog.PlantByte, 
	dbo.LociLog.Next_Station_Name, 
	dbo.Loci.Last_Event_Date, 
	dbo.LociLog.Test_ID, 
	dbo.LociLog.Station
from         
	dbo.LociLog with (index (acs_serial_i)) 
		inner join
			dbo.Loci on 
				dbo.LociLog.ACS_Serial = dbo.Loci.ACS_Serial
where     
	(dbo.Loci.Last_Event_Date > getdate() - 7) 
	AND 
	(dbo.Loci.Next_Station_Name = N'NA')
order by
	dbo.Loci.ACS_Serial, 
	dbo.Loci.Last_Event_Date
GO