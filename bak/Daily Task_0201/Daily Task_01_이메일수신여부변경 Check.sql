-- 이메일 수신여부 변경 --

SELECT 
	CH.*, I.이메일
FROM 
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력 CH
LEFT JOIN 
	[work].[dbo].[db0_clnt_i] I
ON 
	CH.회원번호 = I.회원번호
WHERE 
	변경항목 = '이메일수신여부'
	AND CONVERT(DATE,변경일시) >= CONVERT(DATE,GETDATE() - 1) -- 전날
	-- AND (CONVERT(DATE,변경일시) BETWEEN CONVERT(DATE, GETDATE()-3) AND CONVERT(DATE, GETDATE()-1)) -- 지난 3일
ORDER BY 
	수정후
