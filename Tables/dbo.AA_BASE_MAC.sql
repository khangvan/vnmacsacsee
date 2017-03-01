CREATE TABLE [dbo].[AA_BASE_MAC] (
  [PSC_Serial] [nchar](20) NULL,
  [SAP_Model] [nchar](20) NULL,
  [ACS_Serial] [char](20) NOT NULL,
  [ASP_Key] [varchar](50) NULL,
  [ASP_Value] [varchar](50) NULL,
  [ProdOrder] [nchar](20) NULL,
  [Base_Model] [nchar](20) NULL,
  [Base_SN] [nchar](20) NULL,
  [Assy_Camera_SN] [nchar](20) NULL,
  [GEL_Main] [nchar](20) NULL,
  [GEL_Main_SN] [nchar](20) NULL,
  [Start_Date] [datetime] NULL,
  [Assy_Camera] [nchar](20) NULL,
  [GEL] [varchar](50) NULL,
  [GEL_SN] [varchar](50) NULL,
  [GEL4] [varchar](50) NULL,
  [GEL_SN4] [varchar](50) NULL
)
ON [PRIMARY]
GO