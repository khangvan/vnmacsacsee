SET QUOTED_IDENTIFIER OFF

SET ANSI_NULLS ON
GO

CREATE proc [dbo].[ame_duplicate_limit]
-- Define input parameters
	@StationName 	char(20) = NULL,
	@SourceSAPModel char(20)=NULL,
	@DestinationSAPModel char(20)=NULL

AS
set nocount on

if exists(select * from subtestlimits where station_name=@StationName
   and sap_model_name=@DestinationSAPModel)
	begin
		select 'Error - Destination Model already exists'
		return
	end

if not exists(select * from subtestlimits where station_name=@StationName
   and sap_model_name=@SourceSAPModel)
	begin
		select 'Error - Source Model does not exist'
		return
	end

CREATE TABLE #zzzz (
	[Station_Name] [char] (20) NOT NULL ,
	[SubTest_Name] [char] (20) NOT NULL ,
	[SAP_Model_Name] [char] (20) NOT NULL ,
	[Limit_Type] [char] (1) NOT NULL ,
	[UL] [float] NULL ,
	[LL] [float] NULL ,
	[strLimit] [char] (40) NULL ,
	[flgLimit] [char] (1) NULL ,
	[Units] [char] (10) NOT NULL ,
	[Description] [char] (50) NOT NULL ,
	[Author] [char] (25) NOT NULL ,
	[ACSEEMode] [int] NOT NULL ,
	[SPCParm] [char] (1) NOT NULL ,
	[Hard_UL] [float] NULL ,
	[Hard_LL] [float] NULL ,
	[Limit_Date] [datetime] NOT NULL ,
	[ProductGroup_Mask] [int] NULL ,
) ON [PRIMARY]


insert into #zzzz
select 
	Station_Name ,
	SubTest_Name ,
	SAP_Model_Name ,
	Limit_Type ,
	UL ,
	LL ,
	strLimit,
	flgLimit ,
	Units ,
	Description ,
	Author ,
	ACSEEMode ,
	SPCParm ,
	Hard_UL ,
	Hard_LL ,
	Limit_Date ,
	ProductGroup_Mask
 from subtestlimits
where station_name=@StationName
and sap_model_name=@SourceSAPModel

--select * from #zzzz
update #zzzz
set sap_model_name=@DestinationSAPModel

insert into subtestlimits
(
	Station_Name ,
	SubTest_Name ,
	SAP_Model_Name ,
	Limit_Type ,
	UL ,
	LL ,
	strLimit,
	flgLimit ,
	Units ,
	Description ,
	Author ,
	ACSEEMode ,
	SPCParm ,
	Hard_UL ,
	Hard_LL ,
	Limit_Date ,
	ProductGroup_Mask

)
select 
	Station_Name ,
	SubTest_Name ,
	SAP_Model_Name ,
	Limit_Type ,
	UL ,
	LL ,
	strLimit,
	flgLimit ,
	Units ,
	Description ,
	Author ,
	ACSEEMode ,
	SPCParm ,
	Hard_UL ,
	Hard_LL ,
	Limit_Date ,
	ProductGroup_Mask
 from #zzzz

drop table #zzzz

select 'OK'

--and sap_model_name='4420-11121'
--and sap_model_name='4420-11121-01000'
GO