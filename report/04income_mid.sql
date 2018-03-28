use report
go

-- 0. 월초 작업을 통해 upgrade/downgrade 후원자들을 가려낸다 : 10일 결제일만 지나면 할 수 있는 작업, 굳이 16일까지 기다릴 필요 없음
-- 0-1. 이번달 납부금액이 그 직전 납부금액보다 큰 후원자를 뽑아 upgrade 테이블을 update한다.
INSERT INTO
	[report].[dbo].[upgrade_monthly]
SELECT
	--UP.회원번호, 'Upgrade_Actual donation' AS 그룹명, UP.차액
	UP.회원번호, UP.최근납부금액, UP.직전납부금액, UP.차액,-- MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)) AS 월
	Year(MP.최근납부일) AS UpgradeYear,
	Month(MP.최근납부일) AS UpgradeMonth
FROM
	(
	SELECT
		회원번호, 최근납부금액, 직전납부금액, 최근납부금액 - 직전납부금액 AS 차액
	FROM
	(
		SELECT
			회원번호,
			SUM(CASE WHEN 최근납부일순서=1 THEN 납부금액 END) AS 최근납부금액,
			SUM(CASE WHEN 최근납부일순서=2 THEN 납부금액 END) AS 직전납부금액
		FROM
			(
			SELECT
				A.회원번호, RANK() OVER (PARTITION BY PR.회원번호 ORDER BY PR.납부일 DESC) AS 최근납부일순서, PR.납부금액
			FROM
				(
				SELECT
					회원번호
				FROM
					MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
				WHERE
					정기수시='정기'
					AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)							-- 이번달 1일
					AND 납부일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 16일
				) A
			LEFT JOIN
				MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
			ON
				A.회원번호 = PR.회원번호
			WHERE
				PR.정기수시 = '정기'
				AND PR.환불상태 = ''
				AND PR.납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))		-- 이번달 16일
			) B
		GROUP BY
			회원번호
		) C
	WHERE
		직전납부금액 is not null
	) UP
LEFT JOIN
	(
	SELECT
		회원번호, MAX(납부일) AS 최근납부일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		정기수시='정기'
		AND 환불상태 = ''
		AND 납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))				-- 이번달 16일
	GROUP BY
		회원번호
	) MP
ON
	UP.회원번호 = MP.회원번호
WHERE
	UP.차액 > 0

-- 0-2. 이번달 납부금액이 그 직전 납부금액보다 작은 후원자를 뽑아 downgrade 테이블을 update한다.
INSERT INTO
	[report].[dbo].[downgrade_monthly]
SELECT
	DW.회원번호, DW.최근납부금액, DW.직전납부금액, DW.차액,
	Year(MP.최근납부일) AS DowngradeYear,
	Month(MP.최근납부일) AS DowngradeYear
FROM
	(
	SELECT
		회원번호, 최근납부금액, 직전납부금액, 최근납부금액 - 직전납부금액 AS 차액
	FROM
	(
		SELECT
			회원번호,
			SUM(CASE WHEN 최근납부일순서=1 THEN 납부금액 END) AS 최근납부금액,
			SUM(CASE WHEN 최근납부일순서=2 THEN 납부금액 END) AS 직전납부금액
		FROM
			(
			SELECT
				PR.회원번호, RANK() OVER (PARTITION BY PR.회원번호 ORDER BY PR.납부일 DESC) AS 최근납부일순서, PR.납부금액
			FROM
				(
				SELECT
					회원번호
				FROM
					MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
				WHERE
					정기수시='정기'
					AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)							-- 이번달 1일
					AND 납부일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 16일
				) A
			LEFT JOIN
				MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
			ON
				A.회원번호 = PR.회원번호
			WHERE
				PR.정기수시 = '정기'
				AND PR.환불상태 = ''
				AND PR.납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))		-- 이번달 16일
			) B
		GROUP BY
			회원번호
		) C
	WHERE
		직전납부금액 is not null
	) DW
LEFT JOIN
	(
	SELECT
		회원번호, MAX(납부일) AS 최근납부일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
	WHERE
		정기수시='정기'
		AND 환불상태 = ''
		AND 납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))				-- 이번달 16일
	GROUP BY
		회원번호
	) MP
ON
	DW.회원번호 = MP.회원번호
WHERE
	DW.차액 < 0

-- 0-3. Acquired donor 테이블 업데이트 -- 15일 이후 해야함
-- 0-3-1. New Acquired donor for this month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison],
	'South Korea' AS [Region],
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Year],				-- the year of this month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Month],			-- this month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Date],	-- the first day of this month
	D.회원번호 AS [ConstituentID],
	CASE
	WHEN D.최초등록구분=N'정기' THEN 'Regular'
	WHEN D.최초등록구분=N'일시' THEN 'One-off'
	END AS [Income type],
	CASE
	WHEN D.가입경로=N'거리모집' THEN 'Direct Dialogue'
	WHEN D.가입경로=N'인터넷/홈페이지' THEN 'Web'
	WHEN D.가입경로=N'Lead Conversion' THEN D.가입경로
	ELSE 'Other'
	END AS [Source],
	CASE
	WHEN D.소속 != 'Inhouse' THEN 'Agency'
	ELSE 'Inhouse'
	END AS [Sub-source],
	1 AS [NewDonor_Actual]
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
WHERE	-- donors whose first payment is this month
	D.최초납부년월 = SUBSTRING(CONVERT(varchar(10), DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126), 1, 7)
	AND D.가입일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 16일꺼까지

-- 0-3-1. Reactivation for this month
INSERT INTO [report].[dbo].[supporter_ALC]
SELECT
	'Actual' AS [Comparison],
	'South Korea' AS [Region],
	Year(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Year],				-- the year of this month
	Month(DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Month],			-- this month
	CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)) AS [Date],	-- the first day of this month
	A.회원번호 AS [ConstituentID],
	'Regular' AS [Income Type],
	'Reactivation' AS [Source],
	'Agency' AS [Sub-source],
	1 AS [NewDonor_Actual]
FROM
	(
	SELECT
		H.회원번호, MIN(PR.납부일) 첫결제일
	FROM
		(
		SELECT
			회원번호, 참고일 AS 가입일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
		WHERE
			기록분류 like N'TM_후원재시작%'
			AND 기록분류상세=N'통성-재시작동의'
			AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		) H
	LEFT JOIN
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
	ON
		H.회원번호 = PR.회원번호
	WHERE
		PR.납부일 >= H.가입일
	GROUP BY
		H.회원번호
	) A
WHERE	-- donors whose first payment is last month since they agreed to donate again
	첫결제일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	AND 첫결제일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 16일

-- 1. 전월 income_monthly table의 이름 변경
exec sp_rename 'income_monthly', 'income_monthly_201802'

-- 2. 이번달 15일까지 income을 income_monthly table에 넣음
SELECT
	PR.[회원번호] AS ConstituentID,
	CONVERT(DATE,PR.납부일,126) AS [PaidDate],
	CASE
	WHEN PR.정기수시='정기' THEN 'Regular'
	WHEN PR.정기수시='수시' THEN 'Oneoff'
	END AS [Type],
	CASE
	WHEN PR.[납부방법] = '신용카드' THEN 'CRD'
	WHEN PR.[납부방법] = '계좌이체' THEN 'Bank transfer'
	WHEN PR.[납부방법] = 'GP계좌직접입금' THEN 'Bank transfer'
	WHEN PR.[납부방법] = 'CMS' THEN 'Bank transfer'
	ELSE PR.[납부방법]
	END AS [Paymentmethod],
	CASE
	WHEN PR.정기수시='정기' AND PR.[납부방법] in ('CMS', '계좌이체', 'GP계좌직접입금') THEN '301' -------- 현금납부도 조건에 추가
	WHEN PR.정기수시='정기' AND PR.[납부방법] = '신용카드' THEN '303'
	WHEN PR.정기수시='수시' AND PR.[납부방법] in ('CMS', '계좌이체', 'GP계좌직접입금') THEN '311'
	WHEN PR.정기수시='수시' AND PR.[납부방법] = '신용카드' THEN '312'
	END AS [Account code],
	CONVERT(INT, PR.납부금액) AS [Amount],
	환불상태 AS RefundTF,
	CONVERT(INT, PR.환불총액) AS [Refund amount]
INTO [report].dbo.income_monthly
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
WHERE
	PR.납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0) AND PR.납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))
GO

-- 3. 전월 income_by_cocoa table의 이름 변경
exec sp_rename 'income_by_cocoa', 'income_by_cocoa_201802'


-- 4. 콜을 받고 증액한 사람의 차액
-- 142-02-41	Continuing Support	Upgrade	Outsourcing
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	U.차액 AS Amount,
	'142-02-41' AS COCOA,
	I.[Account code]
INTO
	[report].dbo.income_by_cocoa
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일, 제목
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 like N'TM_후원증액%'
		AND 기록분류상세 like '%성공'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
	) H
ON
	U.회원번호 = H.회원번호
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID]
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	D.회원번호 is null
	OR D.DowngradeMonth < U.UpgradeMonth
GO

-- 자발증액 차액
-- 142-01-41	Continuing Support	Upgrade	Inhouse
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	--CASE
	--WHEN
	--I.[RefundTF] ='' THEN U.차액
	--ELSE -U.차액
	--END AS Amount,
	U.차액 AS Amount,
	'142-01-41' AS COCOA,
	I.[Account code]
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID]
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일, 제목
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 like N'TM_후원증액%'
		AND 기록분류상세 like '%성공'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
	) H
ON
	H.회원번호 = U.회원번호
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	(D.회원번호 is null OR D.DowngradeMonth < U.UpgradeMonth)
	AND H.회원번호 is null
GO

-- 증액한 사람의 원래 금액
-- 140-01-41	Continuing Support	Unprompted
-- 141-02-41	Continuing Support	Prompted	Outsourcing
-- 146-02-41	Continuing Support	Supporter Care	Outsourcing
-- 121-01-41	Acquisition	Direct dialogue	Inhouse-Seoul
-- 126-01-41	Acquisition	Reactivation
-- 127-01-41	Acquisition	Web
-- 128-02-41	Acquisition	Telephone	Outsourcing
-- 130-01-41	Acquisition	Other
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	U.직전납부금액 AS Amount,
	CASE
	WHEN H.회원번호 is not null AND H.기록분류 in ( 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족') THEN '141-02-41'
	WHEN H.회원번호 is not null AND H.기록분류 = 'TM_신용카드_종료예정' THEN '146-02-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Direct Dialogue'	THEN '121-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Web'				THEN '127-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Lead Conversion'	THEN '128-02-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Reactivation'		THEN '126-01-41'
	WHEN ALC.ConstituentID is not null AND ALC.Source = 'Other'				THEN '130-01-41'
	ELSE '140-01-41'
	END AS COCOA,
	I.[Account code]
FROM
	[report].dbo.upgrade_monthly U
INNER JOIN
	(
	SELECT
		*
	FROM
		[report].dbo.income_monthly
	WHERE
		[Type]='Regular'
	) I
ON
	U.회원번호 = I.[ConstituentID]
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 in ('TM_신용카드_종료예정', 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족')
		AND 기록분류상세 like '%동의'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
	) H
ON
	U.회원번호 = H.회원번호 AND I.[PaidDate] >= H.참고일
LEFT JOIN
	(
	SELECT
		*
	FROM
		[report].[dbo].[supporter_ALC]
	WHERE
		[Date] >= CONVERT(DATE, '2018-01-01')
		AND Source in ('Direct Dialogue', 'Lead Conversion', 'Web', 'Other', 'Reactivation')
	) ALC
ON
	U.회원번호 = ALC.ConstituentID
LEFT JOIN
	[report].dbo.downgrade_monthly D
ON
	U.회원번호 = D.회원번호
WHERE
	D.회원번호 is null
	OR D.DowngradeMonth < U.UpgradeMonth
GO


---- 144-01-41	Continuing Support	Special Appeal	Inhouse
--INSERT INTO [report].dbo.income_by_cocoa
--SELECT
--	'Actual' AS [Comparison],
--	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
--	I.Amount AS Amount,
--	'144-01-41' AS COCOA,
--	I.[Account code]
--FROM
--	(
--	SELECT
--		*
--	FROM
--		[report].dbo.income_monthly
--	WHERE
--		[Type]='Oneoff'
--	) I
--LEFT JOIN
--	(
--	SELECT
--		*
--	FROM
--		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
--	WHERE
--		기록분류 = '특별일시후원 요청/문의'
--		AND 참고일 >= CONVERT(DATE, '2018-01-01',126)
--		AND 참고일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
--	) H
--ON
--	I.[ConstituentID] = H.회원번호 AND I.Amount = CONVERT(INT, [dbo].[FN_SPLIT](H.제목,':',2))
--WHERE
--	I.[PaidDate] >= H.참고일
--GO

---- 144-02-41	Continuing Support	Special Appeal	Outsourcing
--INSERT INTO [report].dbo.income_by_cocoa
--SELECT
--	'Actual' AS [Comparison],
--	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
--	I.Amount AS Amount,
--	'144-02-41' AS COCOA,
--	I.[Account code]
--FROM
--	(
--	SELECT
--		*
--	FROM
--		[report].dbo.income_monthly
--	WHERE
--		[Type]='Oneoff'
--	) I
--LEFT JOIN
--	(
--	SELECT
--		*
--	FROM
--		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
--	WHERE
--		기록분류 = 'TM_특별일시후원'
--		AND 기록분류상세='통성-후원동의'
--		AND 참고일 >= CONVERT(DATE, '2018-01-01',126)
--		AND 참고일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
--	) H
--ON
--	I.[ConstituentID] = H.회원번호 AND I.Amount = CONVERT(INT, REPLACE([dbo].[FN_SPLIT](H.제목,':',2),',',''))
--WHERE
--	I.[PaidDate] >= H.참고일
--GO



-- 141-02-41	Continuing Support	Prompted		Outsourcing
-- 146-02-41	Continuing Support	Supporter Care	Outsourcing
-- 재개/결제실패/신용카드 콜을 받고 결제한 사람
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	I.Amount AS Amount,
	CASE
	WHEN H.기록분류 in ( 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족') THEN '141-02-41'
	WHEN H.기록분류 = 'TM_신용카드_종료예정' THEN '146-02-41'
	END AS COCOA,
	I.[Account code]
FROM
	[report].dbo.income_monthly I
LEFT JOIN
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, 참고일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 in ('TM_신용카드_종료예정', 'TM_결제실패_정기_정보오류', 'TM_후원재개_정보오류', 'TM_후원재개_잔액부족')
		AND 기록분류상세 like '%동의'
		AND 참고일 >= CONVERT(DATE, '2018-01-01', 126)
		AND 참고일 <  CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
	) H
ON
	I.[ConstituentID] = H.회원번호
LEFT JOIN
	[report].dbo.income_by_cocoa M
ON
	I.[ConstituentID] = M.[ConstituentID]
WHERE
	I.[PaidDate] >= H.참고일
	AND M.[ConstituentID] is null
GO

-- Acquired donor
--121-01-41		Acquisition	Direct dialogue	Inhouse-Seoul
--126-01-41		Acquisition	Reactivation
--127-01-41		Acquisition	Web
--128-01-41		Acquisition	Telephone	Inhouse
--128-02-41		Acquisition	Telephone	Outsourcing
--130-01-41		Acquisition	Other
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	I.Amount AS Amount,
	CASE
	WHEN ALC.Source = 'Direct Dialogue'	THEN '121-01-41'
	WHEN ALC.Source = 'Web'				THEN '127-01-41'
	WHEN ALC.Source = 'Lead Conversion'	THEN '128-02-41'
	WHEN ALC.Source = 'Reactivation'	THEN '126-01-41'
	ELSE '130-01-41'
	END AS COCOA,
	I.[Account code]
FROM
	(
	SELECT
		*
	FROM
		[report].[dbo].[supporter_ALC]
	WHERE
		[Date] >= CONVERT(DATE, '2018-01-01')
		--AND CONVERT(DATETIME2, [Date]) < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))	-- 이번달 15일까지
		AND Source in ('Direct Dialogue', 'Lead Conversion', 'Web', 'Other', 'Reactivation')
	) ALC
INNER JOIN
	[report].dbo.income_monthly I
ON
	ALC.ConstituentID = I.[ConstituentID]
LEFT JOIN
	[report].dbo.income_by_cocoa M
ON
	ALC.ConstituentID = M.[ConstituentID]
WHERE
	M.[ConstituentID] is null
GO


-- 140-01-41	Continuing Support	Unprompted
INSERT INTO [report].dbo.income_by_cocoa
SELECT
	'Actual' AS [Comparison],
	I.[ConstituentID], I.[PaidDate], I.[Type], I.[Paymentmethod],
	I.Amount AS Amount,
	'140-01-41' AS COCOA,
	I.[Account code]
FROM
	[report].dbo.income_monthly I
LEFT JOIN
	[report].dbo.income_by_cocoa M
ON
	I.[ConstituentID] = M.[ConstituentID] AND I.[Type] = M.[Type]
WHERE
	M.[ConstituentID] is null
GO

-- COCOA별로 쪼개진 금액과 원래 금액 비교
SELECT SUM(Amount) AS income FROM [report].dbo.income_by_cocoa
UNION ALL
SELECT SUM(Amount) AS income FROM [report].dbo.income_monthly
GO

---- 환불건 입력은 생략


-- 홍콩 데이터 확인
SELECT
	*
FROM
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]

-- 홍콩에 데이터 전달하기
INSERT INTO
	[HK].[Korea Report Data].[dbo].[Table_Report_IncomeReport_KR_2018]
	([Comparison], [ConstituentID], [Region], [Paymentmethod], [PaidDate], [Year], [Month], [GL_Middle], [GL_SuffixFormula], [Actual], [Type])
SELECT
	[Comparison],
	[ConstituentID],
	'Korea' AS [Region],
	[Paymentmethod],
	[PaidDate],
	Year(PaidDate) AS [Year],
	CASE
	WHEN Month(PaidDate)=1 THEN 'Jan'
	WHEN Month(PaidDate)=2 THEN 'Feb'
	WHEN Month(PaidDate)=3 THEN 'Mar'
	WHEN Month(PaidDate)=4 THEN 'Apr'
	WHEN Month(PaidDate)=5 THEN 'May'
	WHEN Month(PaidDate)=6 THEN 'Jun'
	WHEN Month(PaidDate)=7 THEN 'Jul'
	WHEN Month(PaidDate)=8 THEN 'Aug'
	WHEN Month(PaidDate)=9 THEN 'Sep'
	WHEN Month(PaidDate)=10 THEN 'Oct'
	WHEN Month(PaidDate)=11 THEN 'Nov'
	WHEN Month(PaidDate)=12 THEN 'Dec'
	END AS [Month],
	[Account code] AS [GL_Middle],
	COCOA AS [GL_SuffixFormula],
	[Amount] AS [Actual],
	[Type]
FROM
	[report].dbo.income_by_cocoa
GO

---- 전월 테이블 백업해두기
SELECT
	*
INTO
	[dbo].[income_account_201802]
FROM
	[dbo].[income_account_2018]

---- Finance report/Monthly report에 보이는 COCOA별 금액 --- 틀려서 삭제할 때는 Budget 빼고 Actual만!
INSERT INTO
	[report].[dbo].[income_account_2018]
SELECT
	[Comparison],
	[ConstituentID],
	[PaidDate],
	Year([PaidDate]) AS [Settlement Year],
	Month([PaidDate]) AS [Settlement Month],
	[Type],
	[Paymentmethod],
	[Amount] AS [Actual],
	NULL AS [Budget],
	[COCOA],
	SUBSTRING([COCOA], 1, 3) AS [Budget code],
	REPLACE(SUBSTRING([COCOA], 5, 5),'-','') AS [Budget subcode],
    [Account code]
FROM
	[report].[dbo].income_by_cocoa
GO

--INSERT INTO
--	[report].[dbo].[income_account_2018]
--SELECT
--	'Budget' AS Comparison,
--	ConstituentID,
--	PaidDate,
--	2018 AS [Settlement Year],
--	3 AS [Settlement Month],
--	Type,
--	[PaymentMethod],
--	[Actual],
--	Budget,
--	GL_SuffixFormula AS COCOA,
--	SUBSTRING(GL_SuffixFormula,1,3) AS [Budget code],
--	REPLACE(SUBSTRING(GL_SuffixFormula,5,5),'-','') AS [Budget subcode],
--	NULL AS [Account code]
--from
--	[dbo].[income_budget_2018] where Month='Mar'
