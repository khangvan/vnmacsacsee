CREATE TABLE [dbo].[ACSControlConsoleSecurities] (
  [ACSCONTROL_ID] [int] IDENTITY,
  [ACSUSerName] [char](50) NULL,
  [ACSUserDomain] [char](20) NULL,
  [ACSBaseSecurity] [int] NULL,
  [ACSGeneralSecurity] [int] NULL,
  [ACSTechSecurity] [int] NULL,
  [ACSSupervisorSecurity] [int] NULL,
  [ACSDeveloperSecurity] [int] NULL,
  [ACSGodSecurity] [int] NULL,
  [ACSAllowLimitsShuffling] [int] NULL,
  CONSTRAINT [PK_ACSControlConsoleSecurities] PRIMARY KEY CLUSTERED ([ACSCONTROL_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO