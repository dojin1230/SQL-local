

-- 웰컴메일 할당 최초입력일 기준 지난주 월요일 - 일요일, 이메일 수신 Y, 회원상태 캔슬 제외 --
-- 쿼리 실행전 db0_clnt_i 최신으로 업데이트 --


SELECT 
	D.최초입력일, D.가입일, I.성명, I.이메일, I.이메일수신여부, I.회원번호, D.회원상태 
FROM 
	[dbo].[db0_clnt_i] I
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
ON
	I.회원번호 = D.회원번호
WHERE 
	CONVERT(DATE, D.최초입력일) BETWEEN CONVERT(DATE, GETDATE()-7) AND CONVERT(DATE, GETDATE()-1)   -- 매주 월요일에 실행. 그렇지 않은 경우 날짜 수정 필요.
	AND 이메일수신여부 = 'Y'
	AND 회원상태 != 'Canceled'
ORDER BY 최초입력일