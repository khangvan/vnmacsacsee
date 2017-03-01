CREATE TABLE [dbo].[riskanalysis] (
  [rid_id] [int] IDENTITY,
  [risktype] [char](20) NULL,
  [risk_acs_serial] [char](20) NULL,
  [risk_station] [int] NULL,
  [risk_action] [smallint] NULL,
  [risk_part_no] [int] NULL,
  [risk_scanned_serial] [char](20) NULL,
  [risk_action_date] [datetime] NULL,
  [risk_start_station] [int] NULL,
  [risk_start_mfg] [datetime] NULL,
  [risk_psc_serial] [char](20) NULL,
  [risk_end_mfg] [datetime] NULL,
  [risk_sales_order] [char](10) NULL,
  [risk_line_item] [int] NULL,
  [risk_sap_model_name] [char](20) NULL,
  [risk_part_no_count] [int] NULL,
  [risk_part_no_name] [char](20) NULL,
  [risk_station_name] [char](20) NULL,
  [risk_machine_name] [char](20) NULL,
  CONSTRAINT [PK_riskanalysis] PRIMARY KEY CLUSTERED ([rid_id])
)
ON [PRIMARY]
GO