SET QUOTED_IDENTIFIER, ANSI_NULLS OFF
GO
CREATE PROCEDURE [dbo].[xoneSAPTestRFCOle] 
 AS

DECLARE @retVal INT
DECLARE @comHandle INT
DECLARE @errorSource VARCHAR(8000)
DECLARE @errorDescription VARCHAR(8000)
DECLARE @retString VARCHAR(100)
declare @iTestValue INT

print 'in onesaptestOle'

-- Initialize the COM component.
--EXEC @retVal = sp_OACreate 'OneSAPBOMFiles.IData', @comHandle OUTPUT
IF (@retVal <> 0)
BEGIN
	-- Trap errors if any
--	EXEC sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
	SELECT [Error Source] = @errorSource, [Description] = @errorDescription
	RETURN
END

print ' Got object'



EXEC @retVal = sp_OASetProperty @comHandle, 'strMessage', 'Arthur'
IF (@retVal <> 0)
BEGIN
	-- Trap errors if any
	EXEC sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
	SELECT [Error Source] = @errorSource, [Description] = @errorDescription
	RETURN
END

print ' set property'

EXEC @retVal = sp_OASetProperty @comHandle, 'so', '0000755510'
IF (@retVal <> 0)
BEGIN
	-- Trap errors if any
	EXEC sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
	SELECT [Error Source] = @errorSource, [Description] = @errorDescription
	RETURN
END

print ' set property so'

EXEC @retVal = sp_OASetProperty @comHandle, 'item', '000001'
IF (@retVal <> 0)
BEGIN
	-- Trap errors if any
	EXEC sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
	SELECT [Error Source] = @errorSource, [Description] = @errorDescription
	RETURN
END

print ' set property item'




set @iTestValue = 12 
-- Call a method into the component
EXEC @retVal = sp_OAMethod @comHandle, 'TestRFCAll', @retString OUTPUT, @iValue = 48

IF (@retVal <> 0)
BEGIN
	-- Trap errors if any
	EXEC sp_OAGetErrorInfo @comHandle, @errorSource OUTPUT, @errorDescription OUTPUT
	SELECT [Error Source] = @errorSource, [Description] = @errorDescription
	RETURN
END

print 'called method'

SELECT @retString

-- Release the reference to the COM object
EXEC sp_OADestroy @comHandle
GO