

SELECT 
	회원번호
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE	
	납부일시중지종료='2017-09'
	AND 납부여부='Y'
	AND 회원상태='Stop_tmp'
	order by 회원상태