SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_LimitEditor_CheckForDestLimitsExist]
@testname char(20),
@model char(20)
 AS
set nocount on



select count(*) as numberfound
from  subtestlimits where
Station_Name = @testname
and SAP_Model_Name = @model
GO