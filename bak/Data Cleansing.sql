USE mrm
go

-- 참고일 오류
SELECT 
	회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE 
	기록분류상세 not in ('미처리','통성-추후재전','통성-설명X')
	AND 참고일 is null
go


-- 신용카드 변경자
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
		결과='성공'
	GROUP BY
		회원코드
	) CP
ON
	C.회원번호 = CP.회원코드
WHERE 
	C.승인일>= CONVERT(varchar(10), DATEADD(day, -30, GETDATE()), 126)
	AND D.회원상태='Freezing'
	AND (H.최근Freezing일 <= C.승인일 OR H.최근Freezing일 <= CP.최근출금일)
ORDER BY
	D.회원번호
go


-- 캔슬기록 불일치
------ 다시 수정 필요
(SELECT 
	회원번호, 기록분류, 기록분류상세, 참고일
FROM 	
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록분류 = 'Cancellation'
	AND 처리진행사항 ='IH-완료' 
	AND 기록분류상세 in ('SS-Canceled', 'Canceled')) H
LEFT JOIN 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON 
	S.회원번호 = H.회원번호
WHERE 
	S.회원상태 !='canceled'
	AND 
EXCEPT 		
(SELECT
	회원번호
FROM 
	dbo.donotCall
GROUP BY 회원번호 )		
AND H.기록분류상세 ='자발_Reactivation'
go

SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력	


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
SELECT 
	*
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 
WHERE 
	회원상태='Freezing' 
	AND (납부일시중지시작 is null OR 납부일시중지종료 !='2020-12')
go

-- 노말 오류
-- 한 번이라도 정기로 결제한 적이 있다면 정기 회원
-- max 참고일만 불러오도록

SELECT
	S.회원번호, S.CMS상태, S.CARD상태, S.CMS증빙자료등록필요, S.총납부건수, S.최종납부년월, S.가입일, H.참고일, H.기록분류, H.기록분류상세
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 P
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON
	P.회원번호 = S.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
ON
	P.회원번호 = H.회원번호
WHERE
	P.정기수시='정기'
	and ((S.CMS상태 not in ('신규완료','신규진행','수정완료','수정진행') and S.CARD상태 !='승인완료') OR S.CMS증빙자료등록필요='Y')
	and S.회원상태='Normal'
	and S.최종납부년월 >= '2017-05'
	and S.총납부건수 >=2
	and S.납부방법 is not null
go

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
	AND 총납부건수='0'
	AND 납부시작년월 is not null
	AND 납부종료년월 is null
	AND 최종납부년월 is null
	AND 납부방법 is not null

SELECT
	*
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 
WHERE
	종료여부='Y'

-- 3주 전 지난 감사콜이 있는지 확인
