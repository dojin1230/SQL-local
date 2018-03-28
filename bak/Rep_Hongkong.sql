use KoreaReportData
go
-- �÷� ���� ��ȯ �� ������ import�Ѵ�. 

-- import�� ���� ������ Ȯ��
SELECT
	*
FROM
	[dbo].[incomeReportKorea]
GO

-- ȫ�� ���Ŀ� �°� ���̺� ���� ����
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

-- ��ȯ�� ������ Ȯ��
SELECT
	*
FROM 
	[dbo].[incomeReportKorea_forHongKong]

-- ������ ���
use master
go

BACKUP DATABASE KoreaReportData
TO  DISK = 'C:\Program Files\Microsoft SQL Server\MSSQL13.MSSQLSERVER\MSSQL\Backup\KoreaReportData.bkp';
GO


-- ȫ�� ���̺� insert
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport]
SELECT 
	*
FROM
	[dbo].[incomeReportKorea_forHongKong]


-- insert�� ������ Ȯ��
SELECT
	*
FROM 
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport]

-- ȫ���� ���� ������ Ȯ��
SELECT
	*
FROM 
	[HK].[salesforce backups].[dbo].[Table_Report_IncomeReport]
WHERE
	Comparison='Budget'