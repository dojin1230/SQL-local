SELECT
	기록분류, 제목, COUNT(*) 건수
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
WHERE
	기록일시>= CONVERT(varchar(10),'2017-09-01', 126) 
	AND 기록일시< CONVERT(varchar(10),'2017-10-01', 126) 
	AND 기록분류 like 'TM%'
	AND (제목 like '%MPC' OR 제목 like '%WV')
	GROUP BY 기록분류, 제목
	ORDER BY 제목
	