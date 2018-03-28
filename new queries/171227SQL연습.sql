SELECT TOP (1000)
*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 record

WHERE 
	참고일 = CONVERT(varchar(10), GETDATE() - 1, 126)





SELECT TOP (100)
	DI.회원번호, T1.기록분류상세, T2.납부일, DI.납부여부, DI.가입경로,
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
		AH.회원번호, AH.기록분류상세
	FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AH
	WHERE 
		AH.기록분류상세 = '반송-x') T1
	ON
		T1.회원번호 = DI.회원번호
LEFT JOIN
	(SELECT 
		PH.회원번호, PH.납부일
	FROM
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_결제정보] PH
	WHERE 
		LEFT(PH.납부일,4) IN (2016, 2017)) T2
	ON
		T2.회원번호 = DI.회원번호

WHERE 
	DI.[회원상태] IN ('Normal', 'Freezing', 'Stop_tmp')
	AND
	T1.기록분류상세 IS NULL
	AND
	T2.납부일 IS NOT NULL
	AND
	DI.납부여부 = 'Y'







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