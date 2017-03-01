SET QUOTED_IDENTIFIER ON

SET ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_SubAssemblyPath_Compute]
@user char(50) 
AS
declare @type int

select @type = Lookup_Type from SubAssemblyPathLookup where user_id = @user

-- lookup by ACS if type =1 , psc if type = 2
if @type = 1  
begin
select distinct y.psc_serial, y.acs_serial, y.firstmodel, y.scanned_serial, y.sap_model_name,asylog.scanned_serial as subscanned_serial, products.sap_model_name as subscanned_model from asylog right outer join
(

select x.psc_serial, x.acs_serial,x.sap_model_name as firstmodel, asylog.scanned_serial,products.sap_model_name from asylog  right outer join
(
select  psc_serial,acs_serial,sap_model_name from assemblies 
inner join  products on sap_count = sap_model_no
where psc_serial in
(
/*
'W60000364'        ,   
'W60000360'       ,    
'W60000370'      ,     
'W60000375'     ,      
'W60000362'    ,       
'W60000371'   ,        
'W60000374'  ,         
'W60000372' ,          
'W60000361',           
'W60000363'           
*/
select acs_serial from subassemblypathlookup where user_id = @user
) 
) x
on x.acs_serial = asylog.acs_serial
inner join assemblies on asylog.scanned_serial = assemblies.acs_serial
inner join  products on sap_count = sap_model_no
where len(scanned_serial) > 0
) y
on y.scanned_serial = asylog.acs_serial
left outer join assemblies on asylog.scanned_serial = assemblies.acs_serial
left outer join  products on sap_count = sap_model_no

end
else
begin
select distinct y.psc_serial, y.acs_serial, y.firstmodel, y.scanned_serial, y.sap_model_name,asylog.scanned_serial as subscanned_serial, products.sap_model_name as subscanned_model from asylog right outer join
(

select x.psc_serial, x.acs_serial,x.sap_model_name as firstmodel, asylog.scanned_serial,products.sap_model_name from asylog  right outer join
(
select  psc_serial,acs_serial,sap_model_name from assemblies 
inner join  products on sap_count = sap_model_no
where psc_serial in
(
/*
'W60000364'        ,   
'W60000360'       ,    
'W60000370'      ,     
'W60000375'     ,      
'W60000362'    ,       
'W60000371'   ,        
'W60000374'  ,         
'W60000372' ,          
'W60000361',           
'W60000363'           
*/
select psc_serial from subassemblypathlookup where user_id = @user
) 
) x
on x.acs_serial = asylog.acs_serial
inner join assemblies on asylog.scanned_serial = assemblies.acs_serial
inner join  products on sap_count = sap_model_no
where len(scanned_serial) > 0
) y
on y.scanned_serial = asylog.acs_serial
left outer join assemblies on asylog.scanned_serial = assemblies.acs_serial
left outer join  products on sap_count = sap_model_no

end
GO