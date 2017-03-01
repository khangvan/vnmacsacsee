CREATE ROLE [webuser]
GO

EXEC sp_addrolemember N'webuser', N'DL\rlperson'
GO

EXEC sp_addrolemember N'webuser', N'dpjordan'
GO

EXEC sp_addrolemember N'webuser', N'dts'
GO

EXEC sp_addrolemember N'webuser', N'rlperson'
GO

EXEC sp_addrolemember N'webuser', N'wdkurth'
GO