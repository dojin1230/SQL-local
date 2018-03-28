SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
WHERE 납부일 >= CONVERT(VARCHAR(10),GETDATE()-180,126)
	AND 정기수시 = '수시'
	AND 납부금액 >= 500000


--(10만원 202)
--(30만원 30)
--(50만원 14)