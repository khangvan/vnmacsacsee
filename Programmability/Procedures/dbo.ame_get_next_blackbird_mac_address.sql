SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_get_next_blackbird_mac_address]
 AS
set nocount on

declare @nextmac as bigint

set @nextmac = 0

declare @macid int

begin transaction

   select @macid = min(id) from mac_range WITH(TABLOCK,UPDLOCK) where next_mac <= range_max

   select @nextmac = next_mac from mac_range WITH(TABLOCK,UPDLOCK) where id = @macid

   update mac_range with(TABLOCK) set next_mac = next_mac + 1 where id =@macid


   
commit transaction

select @nextmac
GO