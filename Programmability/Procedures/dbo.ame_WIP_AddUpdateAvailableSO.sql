SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_WIP_AddUpdateAvailableSO]
@SalesOrders  char(30)  ,
@SAPModel char(30)  ,
@Name char(80) ,
@Street char(50)  ,
@City char(50)  ,
@State char(50)  ,
@PostalCode char(20)  ,
@IntCode char(50)  ,
@OTDDate  datetime  ,
@Quantity int  ,
@QtyBoxed int  ,
@Vendor char(80)  ,
@Country char(80)  ,
@Hierarchy char(20)  ,
@BlockingCode char(50)  ,
@CustPart  char(80)  ,
@Attn char(50)  ,
@PO char(50) 

 AS
set nocount on

declare @soid   int

select @soid = WIPASO_ID from WIPAvailableSalesOrders where WIPASO_SalesOrders = @SalesOrders


if @soid is not null
begin
print 'found sales order'

update  WIPAvailableSalesOrders
set WIPASO_SAPModel =@SAPModel , 
WIPASO_Name = @Name, 
WIPASO_Street = @Street, 
WIPASO_City = @City, 
WIPSAO_State = @State, 
WIPASO_PostalCode = @PostalCode, 
WIPASO_IntCode = @IntCode, 
WIPASO_OTDDate = @OTDDate, 
WIPASO_Quantity = @Quantity, 
WIPASO_QtyBoxed = @QtyBoxed, 
WIPASO_Vendor = @Vendor, 
WIPASO_Country = @Country, 
WIPASO_Hierarchy = @Hierarchy, 
WIPASO_BlockingCode = @BlockingCode, 
WIPASO_CustPart =@CustPart, 
WIPASO_Attn =@Attn, 
WIPASO_PO = @PO
where
WIPASO_ID = @soid

end
else
begin
print 'new sales order'

insert into  WIPAvailableSalesOrders
(
WIPASO_SalesOrders, 
WIPASO_SAPModel, 
WIPASO_Name, 
WIPASO_Street, 
WIPASO_City, 
WIPSAO_State, 
WIPASO_PostalCode, 
WIPASO_IntCode, 
WIPASO_OTDDate, 
WIPASO_Quantity, 
WIPASO_QtyBoxed, 
WIPASO_Vendor, 
WIPASO_Country, 
WIPASO_Hierarchy, 
WIPASO_BlockingCode, 
WIPASO_CustPart, 
WIPASO_Attn, 
WIPASO_PO
)
values
(
@SalesOrders    ,
@SAPModel   ,
@Name ,
@Street   ,
@City  ,
@State   ,
@PostalCode  ,
@IntCode   ,
@OTDDate    ,
@Quantity  ,
@QtyBoxed  ,
@Vendor   ,
@Country   ,
@Hierarchy   ,
@BlockingCode  ,
@CustPart    ,
@Attn   ,
@PO 
)

end


select 'OK'
GO