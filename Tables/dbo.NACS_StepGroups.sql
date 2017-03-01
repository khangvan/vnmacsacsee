CREATE TABLE [dbo].[NACS_StepGroups] (
  [STPGRP_ID] [int] NOT NULL,
  [STPGRP_Name] [varchar](20) NULL,
  [STPGRP_Type] [varchar](20) NULL,
  [STPGRP_Description] [varchar](50) NULL,
  CONSTRAINT [PK_NACS_StepGroups] PRIMARY KEY CLUSTERED ([STPGRP_ID])
)
ON [PRIMARY]
GO