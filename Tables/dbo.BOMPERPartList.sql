CREATE TABLE [dbo].[BOMPERPartList] (
  [PERBOMPartList_ID] [int] IDENTITY,
  [PERBOMPartlist_model] [char](30) NULL,
  [PERBOMPartlist_model_ID] [int] NULL,
  [PERBOMPartlist_Station] [char](30) NULL,
  [PERBOMPartlist_Station_ID] [int] NULL,
  [PERBOMPartlist_Part] [char](30) NULL,
  [PERBOMPartlist_Part_ID] [int] NULL,
  [PERBOMPartlist_Note] [varchar](80) NULL,
  [PERBOMPartlist_Author] [varchar](80) NULL,
  [PERBOMPartlist_Date] [datetime] NULL,
  CONSTRAINT [PK_BOMPERPartList] PRIMARY KEY CLUSTERED ([PERBOMPartList_ID]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO