CREATE TABLE [dbo].[TFFC_KickSub] (
  [TFFC_KICKSUB_ID] [int] IDENTITY,
  [TFFC_KICKSUB_Model] [char](20) NULL,
  [TFFC_KICKSUB_Part] [char](20) NULL,
  [TFFC_KICKSUB_Station] [char](20) NULL,
  [TFFC_KICKSUB_Location] [char](20) NULL,
  [TFFC_KICKSUB_Description] [char](80) NULL,
  CONSTRAINT [PK_TFFC_KickSub] PRIMARY KEY CLUSTERED ([TFFC_KICKSUB_ID])
)
ON [PRIMARY]
GO