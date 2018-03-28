SELECT TOP (1000)
*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 record

WHERE 
	참고일 = CONVERT(varchar(10), GETDATE() - 1, 126)





SELECT TOP (100)
	DI.회원번호, T1.회원번호, T1.기록분류상세, T2.납부일, DI.납부여부, DI.가입경로,
	CASE WHEN
		DI.가입경로 = '거리모집'
		THEN 
		'우편물+달력배송'
		ELSE
		'우편물'
		END
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] DI
LEFT JOIN 
	(SELECT 
		회원번호, 기록분류상세
	FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록]
	WHERE 
		기록분류상세 = '반송-x') T1
	ON
		DI.회원번호 = T1.회원번호
LEFT JOIN
	(SELECT 
		회원번호, 납부일
	FROM
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_결제정보]
	WHERE 
		LEFT(납부일,4) IN (2016, 2017)) T2
	ON
		DI.회원번호 = T2.회원번호

WHERE 
	DI.[회원상태] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	T1.회원번호 IS NULL
	AND
	T2.납부일 IS NOT NULL
	AND
	DI.납부여부 = 'Y'



-----


SELECT TOP (100)
	DI.회원번호, T1.회원번호, T1.기록분류상세, T2.납부일, DI.납부여부, DI.가입경로,
	CASE WHEN
		DI.가입경로 = '거리모집'
		THEN 
		'우편물+달력배송'
		ELSE
		'우편물'
		END
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] DI

LEFT JOIN
	(SELECT 
		회원번호, 납부일
	FROM
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_결제정보]
	WHERE 
		LEFT(납부일,4) IN (2016, 2017)) T2
	ON
		DI.회원번호 = T2.회원번호

WHERE 
	DI.[회원상태] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	DI.회원번호 NOT IN 
	(SELECT 
		회원번호, 기록분류상세
	FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록]
	WHERE 
		기록분류상세 = '반송-x')
	AND
	DI.회원번호 IN
	(SELECT 
		회원번호, 납부일
	FROM
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_결제정보]
	WHERE 
		LEFT(납부일,4) IN (2016, 2017))
	AND
	DI.납부여부 = 'Y'


------



SELECT TOP (100)
	*
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] A
WHERE EXISTS
	(SELECT 
		회원번호
		FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록]
		WHERE
		기록분류상세 = '반송-x'
		)

-------


SELECT TOP (100)
	*
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] A
WHERE 
	A.회원번호 NOT IN
	(SELECT 
		회원번호
		FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록]
		WHERE
		기록분류상세 = '반송-x'
		)


---------








SELECT 
	PH.회원번호, PH.납부일
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_결제정보] PH
WHERE 
	LEFT(PH.납부일,4) IN (2016, 2017)

SELECT 
	AH.회원번호, AH.기록분류상세
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AH
WHERE 
	AH.기록분류상세 = '반송-x'





-- 제목이 I카드변경이고 참고일 날짜랑 카드 최종승인날짜 비교 --


-- 취소자 진행중인 콜 찾아 제외 --

-- 변경이력에서 납부방법이 [계좌이체] 등 잘못된 값으로 들어가는 경우 --

-- 결제실패콜 마감시 프리징 대상자 찾기 후원동의자들중 12월 재출금 실패된경우, 카드승인날짜확인, 카드사한도문의 -- 카드출금승인내역 기준 I카드변경
승인거절/은행잔액부족


거래거절 거래정지카드
회원정보오류처리불가
유효한 회원이 아닙니다.
