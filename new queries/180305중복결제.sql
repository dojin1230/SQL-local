--중복결제 찾기--

SELECT *
FROM
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 
WHERE 정기수시='정기'
	AND 납부일 >= DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-1, 0)	-- 저번달 1일
	AND 납부일 < DATEADD(mm, DATEDIFF(mm, 0, GETDATE())-0, 0)) T
GROUP BY 회원번호
HAVING COUNT(회원번호) > 1


