USE [UT_2025]
GO

/****** Object:  View [db_datawriter].[AN_GROUP_NOM_SALE]    Script Date: 11.07.2025 13:47:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



ALTER VIEW [db_datawriter].[AN_GROUP_NOM_SALE] AS
SELECT
    SALE_GR.[НАЗВАНИЕ_ГРУППЫ_ТОВАРА],
	--SALE_GR.[НАИМЕНОВАНИЕ_ТОВАРА],
    CAST(round(SUM(SALE_GR.[СТОИМОТЬ В МАНАТАХ]), 3) AS DECIMAL(18,3)) AS [СУММА_ТОВАРА],
    round(SUM(SALE_GR.[КОЛИЧЕСТВО]), 2) AS [КОЛИЧЕСТВО],
    ROW_NUMBER() OVER (ORDER BY SUM(SALE_GR.[СУММА]) DESC) AS [НОМЕР_СТРОКИ]
FROM AN_SALE AS SALE_GR
GROUP BY SALE_GR.[НАЗВАНИЕ_ГРУППЫ_ТОВАРА]--, [НАИМЕНОВАНИЕ_ТОВАРА]
GO


