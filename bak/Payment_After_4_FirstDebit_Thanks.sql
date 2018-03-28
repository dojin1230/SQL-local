USE local
go

SELECT 
	I.회원번호, I.성명, I.이메일--, P.납부일, S.총납부건수
FROM 
	[dbo].[db0_clnt_i] I
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 P
ON
	I.회원번호 = P.회원번호 
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 S
ON
	P.회원번호 = S.회원번호
--LEFT JOIN
--	(SELECT 
--		회원번호
--	FROM
--		MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록 
--	WHERE
--		기록분류 = 'Regular E-mail' 
--		AND 기록분류상세 = '1st debit thanks') H
--ON
--	S.회원번호 = H.회원번호
WHERE
	I.이메일수신여부='Y'
	AND P.납부일 >= CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
	AND P.정기수시='정기'
	AND S.최초등록구분='정기'
	AND S.총납부건수=1
	--AND H.회원번호 is null
GO