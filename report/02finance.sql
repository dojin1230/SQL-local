USE report
GO
-- 0. BC/Nicepay 테이블을 update해야 한다.
-- 1. finance_details 테이블을 백업한다.
SELECT
	*
INTO
	[report].[dbo].[finance_details_201801]
FROM
	[report].[dbo].[finance_details]


-- 2. 전월 Income을 Fee/NetIncome 따로 표시하여 finance_details 테이블에 쌓는다.
INSERT INTO [report].dbo.finance_details
SELECT
	Year([Payment date]) AS [Payment year],
	Month([Payment date]) AS [Payment month],
	[Payment date],
	[Regular-One-off],
	Constituent_ID,
	[Payment method],
	[Payment transition result],
	CASE
	WHEN [Payment transition result]='Fail' THEN 0
	ELSE Amount
	END AS Income,
	CASE
	WHEN [Payment method] = 'CMS' THEN Fee
	WHEN [Payment method] = '신용카드' AND [Payment transition result]='Fail' THEN 0
	WHEN [Payment method] in ('신용카드','계좌이체') AND [Payment transition result]='Success' AND N.주문번호 is null THEN Fee
	WHEN [Payment method] = '신용카드' AND [Payment transition result]='Success' AND N.주문번호 is not null THEN BC.[차감_수수료]
	ELSE 0
	END AS Fee,
	CASE
	WHEN [Payment transition result]='Fail' THEN 0-Fee
	WHEN [Payment transition result]='Success' AND N.주문번호 is null THEN Amount-Fee
	WHEN [Payment transition result]='Success' AND N.주문번호 is not null THEN Amount-BC.[차감_수수료]
	END AS [Net income],
	CASE
	WHEN [Regular-One-off] = 'One-off' AND [Payment method] = 'GP계좌직접입금' THEN 'Others'
	WHEN [Regular-One-off] = 'One-off' AND [Payment method] != 'GP계좌직접임금' THEN 'Nicepay'
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = '신용카드' AND N.주문번호 is null THEN 'Nicepay'
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = '신용카드' AND N.주문번호 is not null THEN 'BC'
	WHEN [Regular-One-off] = 'Regular' AND [Payment method] = 'CMS' THEN 'KFTC'
	ELSE 'Others'
	END AS Company
	--N.주문번호,
	--BC.승인번호
FROM
(
	SELECT
		CONVERT(DATE,출금일,126) AS [Payment date],
		'Regular' AS [Regular-One-off],
		회원코드 AS Constituent_ID,
		CASE
		WHEN 결과='성공' THEN 'Success'
		WHEN 결과='실패' THEN 'Fail'
		END AS [Payment transition result],
		신청금액 AS Amount,
		수수료 AS Fee,
		'신용카드' AS [Payment method],
		카드사 AS [CC Company]
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과
	WHERE
		취소일시 =''
	UNION ALL
	SELECT
		CONVERT(DATE,출금일,126) AS [Payment date],
		'Regular' AS [Regular-One-off],
		회원코드 AS Constituent_ID,
		CASE
		WHEN [처리결과]='출금완료' THEN 'Success'
		ELSE 'Fail'
		END AS [Payment transition result],
		신청금액 AS [requested amount],
		수수료 AS [Service fee],
		'CMS' as [Payment method],
		'' AS [CC Company]
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
	UNION ALL
	SELECT
		CONVERT(DATE,결제일,126) as 결제일,
		'One-off' as 구분,
		회원번호,
		'Success' as 결과,
		결제금액 AS Amount,
		수수료 AS Fee,
		CASE
		WHEN 결제방법='계좌이체' THEN '계좌이체'
		WHEN 결제방법='CARD' THEN '신용카드'
		END AS 결제방법,
		CASE
		WHEN 결제방법='CARD' THEN 결제수단정보
		ELSE NULL
		END AS aa
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_일시후원결제결과
	WHERE
		결제취소일시=''
	UNION ALL
	SELECT
		CONVERT(DATE,납부일,126) AS [Payment date],
		CASE
		WHEN 정기수시='정기' THEN 'Regular'
		WHEN 정기수시='수시' THEN 'One-off'
		END AS [Regular-One-off],
		[회원번호] AS Constituent_id,
		'Success' as 결과,
		납부금액 AS Amount,
		0 as 수수료,
		CASE
		WHEN 납부방법='신용카드' THEN 'CRD'
		ELSE [납부방법]
		END AS [Payment method],
		'' AS aa
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		[납부방법] in ('현금납부','GP계좌직접입금')
	) PR
LEFT JOIN
	dbo.Nicepay N
ON
	PR.Constituent_ID = N.주문번호
LEFT JOIN
	dbo.BC
ON
	BC.승인번호 = N.승인번호
WHERE
	PR.[Payment date] >= CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
	AND PR.[Payment date] < CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)

-- 3. 환불건을 입력한다.
INSERT INTO [report].dbo.finance_details VALUES (2018,	2,	'2018-02-13', 'Regular', '82032183', 'CMS',	'Success',	-15000,	0,	-15000,	'KFTC')
GO
INSERT INTO [report].dbo.finance_details VALUES (2018,	2,	'2018-02-12', 'Regular', '82009335', '신용카드',	'Success',	-30000,	-1089,	-28911,	'Nicepay')
GO
