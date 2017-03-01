SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_create_newtest]
@test char(20),
@stationname char(20),
@stationdescription char(50)



AS





insert into Tests
(
TST_TestName,
TST_fInFP,
TST_fInORT,
TST_fInPCB,
TST_fInCum,
TST_fPerformTest,
STN_Name,
STn_Description
)
values
(
@test,
0,
0,
0,
0,
1,
@stationname,
@stationdescription

)



GO