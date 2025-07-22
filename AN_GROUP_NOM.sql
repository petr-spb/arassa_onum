
--ALTER VIEW [db_datawriter].[AN_GROUP_NOM] AS
SELECT NOM._IDRRef AS [IDRREF_NOM], NOM._Code AS [CODE], --NOM._Description AS [NAME_NOM],
NOM._ParentIDRRef as [PARENT_IDRREF], AN_GROUP_PARENT._IDRREF AS PARENT_IDRREF1, AN_GROUP_PARENT._Description,

CASE
	WHEN
		NOM._ParentIDRRef = AN_GROUP_PARENT._IDRREF THEN CONCAT(AN_GROUP_PARENT._Description, ', ', NOM._Description)
		ELSE NOM._Description
END AS [NAME_NOM]

FROM _Reference204 AS NOM

LEFT JOIN AN_GROUP_PARENT ON AN_GROUP_PARENT._IDRREF = NOM._ParentIDRRef

WHERE _Folder = 0X00 AND _Marked = 0X00
GO

-- Старая функция для отображения групп товаров без родительской группы
--ALTER VIEW [db_datawriter].[AN_GROUP_NOM] AS
--SELECT _IDRRef AS IDRREF_NOM, _Code AS [CODE], _Description AS [NAME_NOM] FROM _Reference204

--WHERE _Folder = 0X00 and _Marked = 0x00
--GO
