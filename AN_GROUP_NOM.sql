USE [UT_2025]
GO

/****** Object:  View [db_datawriter].[AN_GROUP_NOM]    Script Date: 11.07.2025 13:45:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [db_datawriter].[AN_GROUP_NOM] AS
SELECT _IDRRef AS IDRREF_NOM, _Code AS [CODE], _Description AS [NAME_NOM] FROM _Reference204

WHERE _Folder = 0X00
GO


