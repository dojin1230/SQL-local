use mrm
go

SELECT
	P.회원번호, P.납부일, P.정기수시, S.가입일
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 P
	LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
ON
	P.회원번호 = S.회원번호
WHERE 
	P.납부일='2017-10-10'
	AND P.정기수시='정기'
	AND S.최초납부년월='2017-10'
	--AND S.이메일='유' 이메일수신여부로 걸르도록 해야함
	
