CREATE TABLE [dbo].[FFC_LookupModels] (
  [FFC_Lookup_ID] [int] IDENTITY,
  [FFC_Lookup_Model] [char](30) NULL,
  CONSTRAINT [PK_FFC_LookupModels] PRIMARY KEY CLUSTERED ([FFC_Lookup_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO