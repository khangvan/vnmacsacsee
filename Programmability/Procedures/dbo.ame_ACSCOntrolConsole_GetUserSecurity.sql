SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[ame_ACSCOntrolConsole_GetUserSecurity]
@username char(50),
@domain char(20)
 AS
set nocount on

declare @iDomainlength int
declare @domainname char(20)

set @iDomainlength = len(rtrim(@domain))
--print @iDomainlength
--print @username
--select * from ACSCONTROLCOnsoleSecurities where ltrim(rtrim(ACSUSerName)) = rtrim(@username)

--select * from ACSCONTROLConsoleSecurities where ACSUSername like 'hq%'
--select @domainname = substring(ACSUSerDomain,1,@iDomainlength) from ACSCONTROLCOnsoleSecurities where ACSUSerName = rtrim(@username)
--print @domainname
select ACSBASESECURITY, ACSGENERALSECURITY, ACSTechSecurity,ACSSupervisorSecurity, ACSDeveloperSecurity, ACSGodSecurity, ACSAllowLimitsShuffling from 
ACSCONTROLCOnsoleSecurities where ACSUserName=@username and substring(ACSUserDomain,1,@iDomainlength)=rtrim(@domain)
GO