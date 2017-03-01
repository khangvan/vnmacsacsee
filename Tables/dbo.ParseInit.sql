CREATE TABLE [dbo].[ParseInit] (
  [class] [nvarchar](5) NULL,
  [Product_Line] [nvarchar](20) NULL,
  [configstart] [smallint] NULL,
  [configlength] [smallint] NULL,
  [customstart] [smallint] NULL,
  [customlength] [smallint] NULL,
  [country] [smallint] NULL,
  [countrylength] [smallint] NULL,
  [scale] [smallint] NULL,
  [scalelength] [smallint] NULL,
  [brick] [smallint] NULL,
  [bricklength] [smallint] NULL,
  [cable] [smallint] NULL,
  [cablelength] [smallint] NULL,
  [EAS] [smallint] NULL,
  [EASlength] [smallint] NULL
)
ON [PRIMARY]
GO