
ALTER VIEW [db_datawriter].[AN_SALE] AS
select
	
	DATEADD(YEAR, -2000, RTU._Date_Time) AS [ДАТА_ДОКУМЕНТА],
	YEAR(DATEADD(YEAR, -2000, RTU._Date_Time)) AS [ГОД_ДОКУМЕНТА],
	MONTH(DATEADD(YEAR, -2000, RTU._Date_Time)) AS [МЕСЯЦ_ДОКУМЕНТА],
	DAY(DATEADD(YEAR, -2000, RTU._Date_Time)) AS [ЧИСЛО_ДОКУМЕНТА],
	RTU._Number AS [НОМЕР_ДОКУМЕНТА],
	O._Description AS [ОРГАНИЗАЦИЯ],
	DOG._Description AS [ДОГОВОР],
	KA._Description AS [КОНТРАГЕНТ],
	KASSA._Description AS [КАССА],
	BANK._Description as [БанковскийСчетОрганизации],
	VAL._Description AS [ВАЛЮТА],
	NOM._Code AS [КОД_ТОВАРА],
	STORE._Description AS [СКЛАД],
	AN_GROUP_NOM.[NAME_NOM] AS [НАЗВАНИЕ_ГРУППЫ_ТОВАРА],
	NOM._Description AS [НАИМЕНОВАНИЕ_ТОВАРА],
	--SHTRIX._Fld16747 AS [ШТРИХКОД],
	ED_IZM._description as [ЕДИНИЦА_ИЗМЕРЕНИЯ],
	USR._Description AS [МЕНЕДЖЕР],
	PODR._Description AS [ПОДРАЗДЕЛЕНИЕ],
	--ED_IZM1._Description AS [УПАКОВКА],
	RTU_NOM._Fld8207 as [КОЛИЧЕСТВО_УПАКОВОК],
	RTU_NOM._Fld8208 as [КОЛИЧЕСТВО],
	VIDY_CEN._Description AS [ВИДЫ_ЦЕН],
	RTU_NOM._Fld8210 AS  [ЦЕНА],
	RTU_NOM._Fld8218 AS [ПРОЦЕНТ_РУЧНОЙ_СКИДКИ],
	RTU_NOM._Fld8216 AS [СУММА_РУЧНОЙ_СКИДКИ],
	RTU_NOM._Fld8219 AS [ПРОЦЕНТ_АВТОМАТИЧЕСКОЙ_СКИДКИ],
	RTU_NOM._Fld8217 AS [СУММА_АВТОМАТИЧЕСКОЙ_СКИДКИ],
	RTU_NOM._Fld8211 AS [СУММА],
	rtu._fld8143 as [СУММА_ДОКУМЕНТА],
	CASE
		WHEN VAL._Description = 'USD' THEN CAST(ROUND((RTU_NOM._Fld8211 * KURS.[КУРС]), 3) AS numeric(25,3))
		ELSE RTU_NOM._Fld8211
	END AS [СТОИМОТЬ В МАНАТАХ],
	CASE
		WHEN VAL._Description = 'ТМТ' THEN CAST(ROUND((RTU_NOM._Fld8211 / (select [КУРС] from AN_KURS where [ВАЛЮТА] = 'USD')), 3) AS numeric(25,3))
		ELSE RTU_NOM._Fld8211
	END AS [СТОИМОСТЬ_В_ДОЛЛАРАХ],
	SUM(RTU_NOM._Fld8211) OVER (PARTITION BY AN_GROUP_NOM.[NAME_NOM]) AS [СУММА_ПО_ГРУППЕ_ТОВАРА],
	CAST(ROUND(
		(SUM(RTU_NOM._Fld8211) OVER (PARTITION BY AN_GROUP_NOM.[NAME_NOM]) / 
		 NULLIF(SUM(RTU_NOM._Fld8211) OVER (), 0)) * 100, 
		2) AS numeric(25,2)) AS [ПРОЦЕНТ_ПО_ГРУППЕ_ТОВАРА]

	
	--(select [КУРС] from AN_KURS where [ВАЛЮТА] = 'USD') as [КУРС]

	--rtu._Fld8195 as [КУРС_ВАЛЮТЫ] --НЕ ОТОБРАЖАЕТ КУРС ВАЛЮТ, ТОЛЬКО 1
	--(SELECT NOM_PROMO._Description
 --    FROM _Document522_VT27416X1 AS RTU_PROMO
 --    LEFT JOIN _Reference204 AS NOM_PROMO ON NOM_PROMO._IDRRef = RTU_PROMO._Fld27413RRef
 --    WHERE RTU_PROMO._Document522_IDRRef = RTU._IDRRef
 --      AND RTU_PROMO._Fld27413RRef = NOM._IDRRef) AS [ПРОМО_ТОВАРЫ],
 --   (SELECT RTU_PROMO._Fld27414
 --    FROM _Document522_VT27416X1 AS RTU_PROMO
 --    WHERE RTU_PROMO._Document522_IDRRef = RTU._IDRRef
 --      AND RTU_PROMO._Fld27413RRef = NOM._IDRRef) AS [КОЛИЧЕСТВО_ПРОМО]


from _Document522X1 as RTU
LEFT JOIN _Reference214 AS O ON O._IDRRef = RTU._Fld8139RRef
LEFT JOIN _Reference120 AS DOG ON DOG._IDRRef = RTU._Fld8162RRef
LEFT JOIN _Reference183 AS KA ON KA._IDRRef = RTU._Fld8140RRef
LEFT JOIN _Reference161 AS KASSA ON KASSA._IDRRef = RTU._Fld8156RRef
LEFT JOIN _Reference60 AS BANK on BANK._IDRRef = rtu._Fld8124RRef
left join _Reference63 as VAL ON VAL._IDRRef = RTU._Fld8128RRef
left join _Reference315 as STORE ON STORE._IDRRef = RTU._Fld8148RRef
left join _Reference246 as USR ON USR._IDRRef = RTU._Fld8141RRef
left join _Reference338 as PODR ON PODR._IDRRef = RTU._Fld8145RRef


left join _Document522_VT8201X1 as RTU_NOM ON RTU._IDRRef = RTU_NOM._Document522_IDRRef
LEFT JOIN _Reference204 AS NOM ON NOM._IDRRef = RTU_NOM._Fld8203RRef
JOIN AN_GROUP_NOM ON AN_GROUP_NOM.IDRREF_NOM = NOM._ParentIDRRef
LEFT JOIN _Reference366 AS ED_IZM ON ED_IZM._IDRRef = NOM._Fld22590RRef
--LEFT JOIN _Reference336 AS ED_IZM1 ON ED_IZM1._IDRRef = RTU_NOM._Fld8206RRef
--LEFT JOIN _InfoRg16746 AS SHTRIX ON SHTRIX._Fld16748RRef = NOM._IDRRef
LEFT JOIN _Reference92 AS VIDY_CEN ON VIDY_CEN._IDRRef = RTU_NOM._Fld8209RRef
LEFT JOIN AN_KURS AS KURS ON KURS.ID_VAL = VAL._IDRRef



WHERE RTU._Marked = 0X00 AND RTU._Posted = 0X01 AND NOM._Marked = 0X00 --and RTU._Number = '01ЦБ-012904'
--and VAL._Description <> 'ТМТ'

--ORDER BY RTU._Number
GO


