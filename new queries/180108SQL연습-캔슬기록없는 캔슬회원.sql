

-- 회원상태가 canceled 인데 캔슬 기록이 없는 회원 -- 

SELECT TOP (100)
	DI.회원번호, DI.회원상태, DI.납부여부, DI.가입경로
	
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] DI
LEFT JOIN
	(SELECT 
		* 
	FROM 
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] 
	WHERE
		기록분류 = 'Cancellation') AR
ON
	DI.회원번호 = AR.회원번호
WHERE 
	DI.[회원상태] = 'canceled'
	AND
	AR.[회원번호] IS NULL
	


-- 회원상태가 Freezing 인데 기록이 없는 회원 -- 

SELECT TOP (100)
	DI.회원번호, DI.회원상태, DI.납부여부, DI.가입경로
	
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] DI

LEFT JOIN
	(SELECT 
	* 
	FROM
		[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록]
	WHERE 
		기록분류 = 'freezing') AR
ON
	DI.회원번호 = AR.회원번호
WHERE 
	DI.[회원상태] = 'freezing'
	AND
	AR.[회원번호] IS NULL