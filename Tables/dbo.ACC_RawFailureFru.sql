CREATE TABLE [dbo].[ACC_RawFailureFru] (
  [SFL_FL_ID] [int] IDENTITY,
  [SFL_Failed] [datetime] NULL,
  [SFL_cORT] [char](10) NULL,
  [SFL_ORT] [tinyint] NULL,
  [SFL_SAPName] [char](80) NULL,
  [SFL_SN] [char](80) NULL,
  [SFL_Station] [char](80) NULL,
  [SFL_Failure] [char](80) NULL,
  [SFL_cCritical] [char](10) NULL,
  [SFL_Critical] [tinyint] NULL,
  [SFL_FruCode] [int] NULL,
  [SFL_FruDescription] [char](80) NULL,
  [SFL_ActionCode] [int] NULL,
  [SFL_ActionDescription] [char](80) NULL,
  [SFL_Comment] [char](80) NULL,
  [SFL_Comment2] [char](80) NULL,
  [SFL_Category] [char](80) NULL,
  [SFL_RootCause] [char](80) NULL,
  [SFL_Preventative] [char](80) NULL,
  CONSTRAINT [PK_ACC_RawFailureFru] PRIMARY KEY CLUSTERED ([SFL_FL_ID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO