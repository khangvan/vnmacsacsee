CREATE TABLE [dbo].[ACSSerialNumbers] (
  [Start_Station] [int] NOT NULL,
  [Top_Model_Prfx] [char](5) NOT NULL,
  [Last_ACS_Serial_Seq] [int] NOT NULL,
  [Assign_Date] [datetime] NULL,
  [ASN_ID] [int] IDENTITY,
  CONSTRAINT [PK_ACSSerialNumbers] PRIMARY KEY CLUSTERED ([ASN_ID]) WITH (FILLFACTOR = 90)
)
ON [PRIMARY]
GO

ALTER TABLE [dbo].[ACSSerialNumbers] WITH NOCHECK
  ADD CONSTRAINT [FK_ACSSerialNumbers_Stations] FOREIGN KEY ([Start_Station]) REFERENCES [dbo].[Stations] ([Station_Count])
GO