CREATE TABLE [dbo].[TFFC_BoxCounter] (
  [BOXCNT_ID] [int] IDENTITY,
  [BOXCNT_PO_TO] [char](20) NULL,
  [BOXCNT_Model] [char](20) NULL,
  [BOXCNT_Current] [int] NULL,
  CONSTRAINT [PK_TFFC_BoxCounter] PRIMARY KEY CLUSTERED ([BOXCNT_ID])
)
ON [PRIMARY]
GO