use [report]
GO

-- 0. 저번달에 Mid-Income 때 update해뒀던 upgrade/downgrade 데이터를 삭제한다.
DELETE FROM
	[report].[dbo].[upgrade_monthly]
WHERE
	UpgradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO

DELETE FROM
	[report].[dbo].[downgrade_monthly]
WHERE
	DowngradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))
GO

-- 1. 저번달 납부금액이 그 직전 납부금액보다 큰 후원자를 뽑아 upgrade 테이블을 update한다.
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
				PR.회원번호, RANK() OVER (PARTITION BY PR.회원번호 ORDER BY PR.납부일 DESC) AS 최근납부일순서, PR.납부금액
			FROM
				(
				SELECT
					회원번호
				FROM
					MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
				WHERE
					정기수시='정기'
					AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- 저번달 1일
					AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- 이번달 1일
				) A
			LEFT JOIN
				MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
			ON
				A.회원번호 = PR.회원번호
			WHERE
				PR.정기수시 = '정기'
				AND PR.환불상태 = ''
				AND PR.납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- 이번달 1일
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
		AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		회원번호
	) MP
ON
	UP.회원번호 = MP.회원번호
WHERE
	UP.차액 > 0

-- 2. 저번달 납부금액이 그 직전 납부금액보다 작은 후원자를 뽑아 downgrade 테이블을 update한다.
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
					AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- 저번달 1일
					AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- 이번달 1일
				) A
			LEFT JOIN
				MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
			ON
				A.회원번호 = PR.회원번호
			WHERE
				PR.정기수시 = '정기'
				AND PR.환불상태 = ''
				AND PR.납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)		-- 이번달 1일
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
		AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0)
	GROUP BY
		회원번호
	) MP
ON
	DW.회원번호 = MP.회원번호
WHERE
	DW.차액 < 0

-- 3. 저번달 Upgrade 후원자들을 그룹에 할당한다.
SELECT
	UP.회원번호, 'Upgrade_Actual donation' AS 그룹명
FROM
	[report].[dbo].[upgrade_monthly] UP
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	UP.회원번호 = D.회원번호
WHERE
	Up.UpgradeMonth = MONTH(DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0))	-- 업그레이드한 달이 직전달인 사람만
	AND D.회원상태 = 'Normal'												-- 회원상태 Normal인 사람만


-- 4. 재시작 동의한 사람들 중 전월에 첫 납부를 한 후원자들을 그룹에 할당한다. //자발은 안포함하는지?
SELECT
	A.회원번호, 'Reactivation_Actual donation' AS 그룹명
FROM
	(
	SELECT
		H.회원번호, MIN(PR.납부일) 첫결제일
	FROM
		(
		SELECT
			회원번호, 참고일 AS 재가입일
		FROM
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
		WHERE
			기록분류=N'TM_후원재시작'    --// 재시작 연간 재시작 자발해지 자발 Reactivation??
			AND 기록분류상세=N'통성-재시작동의'
		) H
	LEFT JOIN
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
	ON
		H.회원번호 = PR.회원번호
	WHERE
		PR.납부일 >= H.재가입일
	GROUP BY
		H.회원번호
	) A
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	A.회원번호 = D.회원번호
WHERE	-- donors whose first payment is last month since they agreed to donate again
	A.첫결제일 >= CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0), 126)
	AND A.첫결제일 < CONVERT(DATE, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0), 126)
	AND D.회원상태 = 'Normal'

-- 5. 소프트 프리징 타게팅한다.
SELECT
	DD.회원번호,
	'Freezing-insufficient funds' AS [기록분류/상세분류],
	CONVERT(DATE,GETDATE(),126) AS 일자,
	'IH-완료' AS 구분1,
	'F' AS 제목,
	CONVERT(DATE,GETDATE(),126) AS 참고일,
	COUNT(DD.회원번호) AS 미납횟수
FROM
	(SELECT
		D.회원번호, D.회원상태
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
	INNER JOIN
		(SELECT 출금일, 회원코드, 신청금액,
			CASE
				WHEN 처리결과 = '출금완료' THEN '성공'
				ELSE '실패'
			END AS 결과,
			결과메세지,
			CASE
				WHEN 결과메세지 LIKE '%잔액%' THEN 'SOFT'
				--WHEN 결과메세지 LIKE '%잔고%' THEN 'SOFT'
				--WHEN 결과메세지 LIKE '%한도%' THEN 'SOFT'
				WHEN 처리결과 = '출금완료' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CMS' AS pymt_mtd
		FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
		UNION ALL
		SELECT 출금일, 회원코드, 신청금액, 결과, 실패사유,
			CASE
				WHEN 실패사유 LIKE '%잔액%' THEN 'SOFT'
				WHEN 실패사유 LIKE '%잔고%' THEN 'SOFT'
				WHEN 실패사유 LIKE '%한도%' THEN 'SOFT'
				WHEN 결과 = '성공' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CRD' AS pymt_mtd
		FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과) BR_CR
	ON D.회원번호 = BR_CR.회원코드 		-- 후원자정보에 CMS 및 카드 결제결과 조인 (기존쿼리대로 이너조인 되어있으나 레프트 조인도 무방)
	LEFT JOIN
		(
		SELECT
			일련번호, ID, 회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
		FROM
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
		WHERE
			기록분류 = 'TM_후원재개_잔액부족'
			AND 기록분류상세 = '통성-재개동의'
			AND CONVERT(date,참고일) >= CONVERT(date, DATEADD(MONTH, -3, GETDATE()), 126)
		) H
	ON
		D.회원번호 = H.회원번호    	-- 후원자정보에 관리기록 조인
	WHERE (CONVERT(VARCHAR(7),D.최종납부년월) < CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
		OR D.최종납부년월 IS NULL)  -- 마지막으로 납부한 달이 4개월 이전이거나 납부기록이 없는 경우만 추출 (예: 1월초 작업시 최종납부년월이 전년도 8월 이전)
		AND BR_CR.결과 = '실패'			-- 카드 및 CMS 결제결과 출금 실패한 경우
		AND BR_CR.TYPE = 'SOFT'			-- 실패사유가 잔액/잔고/한도 문제인 경우
		AND CONVERT(VARCHAR(7),BR_CR.출금일) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)  -- 결제결과 중 출금일이 4개월 이내인 경우만 선택
		AND H.회원번호 IS NULL			-- 3개월 이내에 잔액부족 콜을 받고 동의한 경우 제외
	) DD
GROUP BY
	DD.회원번호, DD.회원상태
HAVING
	COUNT(DD.회원번호) >= 8
	AND DD.회원상태 = 'normal'

-- 정기납부가 종료된 회원들 Cancel로 변경한다.
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(
	SELECT
		*
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
	WHERE
		종료년월 >= SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 126), 1, 7)
		OR 상태 in ('대기','진행')
	) PL
ON
	D.회원번호 = PL.회원번호
WHERE
	D.회원상태 = 'Normal'
	AND D.최초등록구분 = '정기'
	AND PL.회원번호 is null
