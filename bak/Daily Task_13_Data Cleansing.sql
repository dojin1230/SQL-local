-- 가입경로 NULL값
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE
	가입경로 is null


-- 참고일 NULL값 
SELECT 
	회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE 
	기록분류상세!='미처리' AND
	참고일 is null
go


-- CMS 변경자 : 최근 30일 내에 CMS 정보 변경했는데도 Freezing으로 남아있는 사람
SELECT 
	D.회원번호, D.회원상태, D.CMS상태, H.기록분류, H.기록분류상세, H.최근Freezing일, C.신청일, CP.최근출금일 
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D 
LEFT JOIN 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보 	 C
ON 
	C.회원번호 = D.회원번호
LEFT JOIN 
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, MAX(참고일) 최근Freezing일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류='Freezing'
	GROUP BY
		회원번호, 기록분류, 기록분류상세
	)H
ON 
	D.회원번호 = H.회원번호
LEFT JOIN 
	(SELECT 
		회원코드, MAX(출금일) 최근출금일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
	WHERE 
		처리결과=N'출금완료'
	GROUP BY
		회원코드
	) CP
ON
	C.회원번호 = CP.회원코드
WHERE 
	C.신청일>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND C.신청구분 = N'신규' 	
	AND D.회원상태='Freezing'
	AND (H.최근Freezing일 <= C.신청일 OR H.최근Freezing일 <= CP.최근출금일)
ORDER BY
	D.회원번호
go


-- 신용카드 변경자 : 최근 30일 내에 신용카드 변경했는데도 Freezing으로 남아있는 사람
SELECT 
	D.회원번호, D.회원상태, D.CARD상태, H.기록분류, H.기록분류상세, H.최근Freezing일, C.승인일, CP.최근출금일 
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D 
LEFT JOIN 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보 C
ON 
	C.회원번호 = D.회원번호
LEFT JOIN 
	(
	SELECT
		회원번호, 기록분류, 기록분류상세, MAX(참고일) 최근Freezing일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류='Freezing'
	GROUP BY
		회원번호, 기록분류, 기록분류상세
	)H
ON 
	D.회원번호 = H.회원번호
LEFT JOIN 
	(SELECT 
		회원코드, MAX(출금일) 최근출금일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과
	WHERE 
		결과=N'성공'
	GROUP BY
		회원코드
	) CP
ON
	C.회원번호 = CP.회원코드
WHERE 
	C.승인일>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND D.회원상태 = 'Freezing'
	AND (H.최근Freezing일 <= C.승인일 OR H.최근Freezing일 <= CP.최근출금일)
ORDER BY
	D.회원번호
go


-- 캔슬 
------ 다시 수정 필요
--SELECT
--	H.회원번호, H.후원취소일, S.회원상태
--(SELECT 
--	회원번호, MAX(참고일) AS 후원취소일
--FROM 	
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
--WHERE
--	기록분류 = 'Cancellation'
--	AND 처리진행사항 ='IH-완료' 
--	AND 기록분류상세 in ('SS-Canceled', 'Canceled')
--GROUP BY 
--	회원번호) H
--LEFT JOIN 
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
--ON 
--	S.회원번호 = H.회원번호
--WHERE 
--	S.회원상태 !='canceled'

--SELECT
--	*
--FROM
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력	

-- 회원 상태 오류로 합치기 
-- 캔슬 오류
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
WHERE 
	회원상태='canceled' 
	AND (납부여부!='N' OR 납부일시중지시작 is not null OR 납부일시중지종료 is not null)
go

-- 프리징 오류
-- 프리징 건 날짜 불러오도록 수정 : 반드시 필요하지는 않음
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
WHERE 
	회원상태='Freezing' 
	AND (납부일시중지시작 is null OR 납부일시중지종료 !='2020-12')
go

-- 일시중지자 오류
SELECT
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
WHERE
	납부일시중지시작 is not null
	AND 납부일시중지종료 !='2020-12'
	AND 회원상태 != 'Stop_tmp'
GO

---- 일시후원자 제외해야함
---- 노말 오류
--SELECT
--	회원번호, 회원상태, 납부일시중지시작, 납부일시중지종료, 납부여부, 최종납부년월, 총납부건수
--FROM 
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
--WHERE
--	(납부일시중지시작 is not null OR 납부일시중지종료 is not null OR 납부여부='N')
--	AND 회원상태 = 'Normal'
--ORDER BY 최종납부년월 DESC

-- CMS 증빙자료 등록 필요한 사람들
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
WHERE
	CMS증빙자료등록필요 = 'Y'
	AND 회원상태 =  'Normal'
	AND 가입일 < CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)

-- 약정금액 종료 Y 종료년월 없음
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 
WHERE
	종료여부='Y'
	AND (종료년월 is null OR 종료년월='')

-- 일시후원 오류	
-- 납부항목의 정기/일시 여부를 볼 수 있어야 더 완벽한 쿼리 짤 수 있음 dbo.UV_GP_후원약정금액정보 
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보
WHERE 최초등록구분='일시'
	AND 회원상태='Normal'
	AND 납부여부='Y'
	AND 납부시작년월 is not null
	AND 납부종료년월 is null
	--AND 최종납부년월 is null
	AND 납부방법 is not null

	
-- 다수콜 중복
SELECT 
	H.회원번호, H.기록분류, H.기록분류상세, H.참고일, H.처리진행사항
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
WHERE
	H.회원번호 IN
		(SELECT 
			S.회원번호
		FROM 
			MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
		LEFT JOIN
			MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
		ON 
			S.회원번호 = H.회원번호
		WHERE
			H.처리진행사항 in (N'SK-진행',N'IH-지연',N'IH-진행')
			AND H.기록분류상세 !=N'제외'
			AND H.기록분류 not in (N'결제관련 요청/문의',N'캠페인관련 요청/문의/불만사항',N'개인 정보변경 요청/문의','기타','Impact report','Other mailings','Welcome pack',N'세금관련문의','Annual report')
		GROUP BY
			S.회원번호
		HAVING 
			COUNT(S.회원번호) >= 2)
	AND H.처리진행사항 in (N'SK-진행',N'IH-지연',N'IH-진행')
ORDER BY
	H.회원번호

	
-- 3주 지났는데도 마감 안 된 감사콜이 있는지 확인
SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록분류=N'TM_감사' AND
	처리진행사항 not in (N'SK-완료', N'IH-완료') AND
	기록일시 < CONVERT(varchar(10), DATEADD(day, -21, GETDATE()), 126)


-- TM 콜 처리진행사항이 잘못된 것
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
WHERE 기록분류 LIKE 'TM%' 
	AND 처리진행사항 IN (N'SK-진행',N'SK-지연') 
	AND 기록분류상세 NOT IN (N'무응',N'통성-설명X',N'미처리',N'통성-추후재전')
	OR 처리진행사항 is null
ORDER BY 
	기록분류, 기록분류상세
GO

-- 종료 안된 정기납부정보가 두 개 이상인 것
--SELECT 
--	회원번호, 종료여부
--FROM 
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 
--GROUP BY
--	회원번호, 종료여부
--HAVING
--	종료여부 = 'N'
--	AND 회원번호 >= 2
--ORDER BY 회원번호

-- 기간 후원자 점검 
--(
SELECT
	회원번호
FROM
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보
WHERE
	납부종료년월='2017-12'
	AND 회원상태 != 'canceled' 
	AND 최초등록구분 = N'정기'
--	) S
--ON
--	P.회원번호 = S.회원번호
--WHERE
--	P.상태=N'종료'
--	AND P.종료여부 = 'N'
--	AND P.종료년월 != ''
--	AND P.종료년월 < '2017-12'
--	AND S.회원번호 is null
--GROUP BY
--	P.회원번호


use mrm
go

SELECT
	count(회원번호), 성명, 휴대전화번호
FROM
	[dbo].[db0_clnt_i]
WHERE
	휴대전화번호 is not null
GROUP BY
	성명, 휴대전화번호
HAVING 
	count(회원번호) >= 2

