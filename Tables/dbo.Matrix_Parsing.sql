﻿CREATE TABLE [dbo].[Matrix_Parsing] (
  [Class] [char](5) NOT NULL,
  [Product_Line] [char](20) NOT NULL,
  [Format_File_start] [smallint] NULL,
  [Format_File_length] [smallint] NULL,
  [SModel_start] [smallint] NULL,
  [SModel_length] [smallint] NULL,
  [Power_start] [smallint] NULL,
  [Power_length] [smallint] NULL,
  [Interface_start] [smallint] NULL,
  [Interface_length] [smallint] NULL,
  [Config_start] [smallint] NULL,
  [Config_length] [smallint] NULL,
  [Top_start] [smallint] NULL,
  [Top_length] [smallint] NULL,
  [SInterface_start] [smallint] NULL,
  [SInterface_length] [smallint] NULL,
  [Scale_start] [smallint] NULL,
  [Scale_length] [smallint] NULL,
  [Option_0_start] [smallint] NULL,
  [Option_0_length] [smallint] NULL,
  [Option_1_start] [smallint] NULL,
  [Option_1_length] [smallint] NULL,
  [Option_2_start] [smallint] NULL,
  [Option_2_length] [smallint] NULL,
  [Option_3_start] [smallint] NULL,
  [Option_3_length] [smallint] NULL,
  [Option_4_start] [smallint] NULL,
  [Option_4_length] [smallint] NULL,
  [Option_5_start] [smallint] NULL,
  [Option_5_length] [smallint] NULL,
  [Option_6_start] [smallint] NULL,
  [Option_6_length] [smallint] NULL,
  [Option_7_start] [smallint] NULL,
  [Option_7_length] [smallint] NULL,
  [Option_8_start] [smallint] NULL,
  [Option_8_length] [smallint] NULL,
  [Option_9_start] [smallint] NULL,
  [Option_9_length] [smallint] NULL,
  CONSTRAINT [PK_Matrix_Parsing] PRIMARY KEY CLUSTERED ([Class]) WITH (FILLFACTOR = 80)
)
ON [PRIMARY]
GO