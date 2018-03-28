SELECT 회원번호, count(*)
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
GROUP BY 회원번호
HAVING COUNT(*) > 1
ORDER BY 회원번호

--- 연습

SELECT 회원번호, COUNT(*)
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
GROUP BY 회원번호

SELECT 회원번호, RANK() OVER(ORDER BY 일련번호)
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보

SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC), *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보



--- 

SELECT ROW_NUMBER() OVER(PARTITION BY PL.회원번호 ORDER BY PL.일련번호 DESC), *
FROM 
(SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 
WHERE 시작년월 != 종료년월) PL		-- 일시후원 아닌 것만 선택
LEFT JOIN
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
GROUP BY 회원번호
HAVING COUNT(*) > 1) TMP1			-- 납부항목 2건 이상만 선택
ON PL.회원번호 = TMP1.회원번호
WHERE TMP1.회원번호 IS NOT NULL




--  select A.일련번호, A.회원번호, A.금액, B.일련번호, B.금액
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  cross join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 B
--  where A.회원번호 = b.회원번호
--  and a.일련번호 > b.일련번호
--  and a.금액 > b.금액
 

(SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 PL
LEFT JOIN
	(SELECT 회원번호
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
	GROUP BY 회원번호
	HAVING COUNT(*) > 1) TMP1
ON PL.회원번호 = TMP1.회원번호
WHERE PL.시작년월 != PL.종료년월
	AND TMP1.회원번호 IS NOT NULL) -- 납부항목 두건 이상이고


