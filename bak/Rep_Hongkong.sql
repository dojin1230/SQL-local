use KoreaReportData
go
-- 컬럼 형식 변환 후 엑셀을 import한다. 

-- import된 엑셀 데이터 확인
SELECT
	*
FROM
	[dbo].[incomeReportKorea]
GO

-- 홍콩 형식에 맞게 테이블 새로 생성
SELECT
	'Actual' AS [Comparison], 
	[Donor ID] AS [ConstituentID],
	NULL AS [OpportunityID],
	NULL AS [TransactionID],
	'Korea' AS [Region],
	[Payment Method] AS [Paymentmethod], 
	[Debit success date] AS [PaidDate], 
	CAST(2017 AS INT) AS [Year], 
	[Settlement month] AS [Month], 
	[Account code] AS [GL_Middle], 
	COCOA AS [GL_SuffixFormula],
	CASE 
	WHEN [Regular-One-off]='Regular' then [Regular amount] 
	WHEN [Regular-One-off]='One-off' then [Oneoff amount] 
	END AS [Actual],
	NULL AS [Budget], 
	[Regular-One-off] AS [Type], 
	NULL AS [CardType], 
	NULL AS [ExpiredCardType], 
	NULL AS [TLIID], 
	NULL AS [RGLIID], 
	'' AS [CreatedDate], 
	NULL AS [Status]
INTO
	[dbo].[incomeReportKorea_forHongKong]
FROM
	[dbo].[incomeReportKorea]
GO

-- 변환된 데이터 확인
SELECT
	*
FROM 
	[dbo].[incomeReportKorea_forHongKong]

-- 데이터 백업
use master
go

BACKUP DATABASE KoreaReportData
TO  DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\KoreaReportData.bkp';
GO


-- 홍콩 테이블에 insert
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport]
SELECT 
	*
FROM
	[dbo].[incomeReportKorea_forHongKong]


-- insert된 데이터 확인
SELECT
	*
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport]

-- 홍콩의 원래 데이터 확인
SELECT
	*
FROM 
	[HK].[salesforce backups].[dbo].[Table_Report_IncomeReport]
WHERE
	Comparison='Budget'