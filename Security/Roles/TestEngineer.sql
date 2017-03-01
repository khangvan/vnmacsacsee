CREATE ROLE [TestEngineer]
GO

EXEC sp_addrolemember N'TestEngineer', N'DL\rlperson'
GO

EXEC sp_addrolemember N'TestEngineer', N'DL\tmanguyen'
GO

EXEC sp_addrolemember N'TestEngineer', N'dpjordan'
GO

EXEC sp_addrolemember N'TestEngineer', N'rlperson'
GO

EXEC sp_addrolemember N'TestEngineer', N'srbonafede'
GO

EXEC sp_addrolemember N'TestEngineer', N'wdkurth'
GO