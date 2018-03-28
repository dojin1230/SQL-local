--SELECT 회원번호, count(*)
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--GROUP BY 회원번호
--HAVING COUNT(*) > 1
--ORDER BY 회원번호

----- 연습

--SELECT 회원번호, COUNT(*)
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--GROUP BY 회원번호

--SELECT 회원번호, RANK() OVER(ORDER BY 일련번호)
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보








--DROP TABLE IF EXISTS #TMP1

--SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *

--INTO #TMP1


--SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--FROM
--(SELECT A.*
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--LEFT JOIN
--(SELECT 회원번호 
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--GROUP BY 회원번호
--HAVING COUNT(회원번호) > 1) B
--ON A.회원번호 = B.회원번호
--WHERE A.시작년월 != A.종료년월
--AND B.회원번호 IS NOT NULL) TMP1 -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정




--  select A.일련번호, A.회원번호, A.금액, B.일련번호, B.금액
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  cross join MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 B
--  where A.회원번호 = b.회원번호
--  and a.일련번호 > b.일련번호
--  and a.금액 > b.금액
 
--(
--SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--FROM
--(SELECT A.*
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--LEFT JOIN
--(SELECT 회원번호 
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--GROUP BY 회원번호
--HAVING COUNT(회원번호) > 1) B
--ON A.회원번호 = B.회원번호
--WHERE A.시작년월 != A.종료년월
--AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
--) TMP2




--SELECT *
--FROM 
--(SELECT *
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--WHERE 시작년월 != 종료년월) A
--CROSS JOIN 
--(SELECT *
--FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--WHERE 시작년월 != 종료년월) B
--WHERE A.회원번호 = B.회원번호
--AND A.일련번호 > B.일련번호
--AND A.금액 > B.금액
--ORDER BY A.회원번호





SELECT *
FROM
  (
  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
  FROM
  (SELECT A.*
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
  LEFT JOIN
  (SELECT 회원번호
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
  GROUP BY 회원번호
  HAVING COUNT(회원번호) > 1) B
  ON A.회원번호 = B.회원번호
  WHERE A.시작년월 != A.종료년월
  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
  ) T1
CROSS JOIN
  (
  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
  FROM
  (SELECT A.*
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
  LEFT JOIN
  (SELECT 회원번호
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
  GROUP BY 회원번호
  HAVING COUNT(회원번호) > 1) B
  ON A.회원번호 = B.회원번호
  WHERE A.시작년월 != A.종료년월
  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
  ) T2
WHERE
  T1.회원번호 = T2.회원번호
  AND T1.일련번호 > T2.일련번호
  AND T1.금액 > T2.금액
  AND T1.ROWN = 1
  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE(), 126)
  AND T2.ROWN = 2


  SELECT CONVERT(DATE, GETDATE())   -- 2018-02-06
  SELECT CONVERT(VARCHAR, GETDATE())   -- 02 6 2018 10:56AM
  SELECT CONVERT(VARCHAR(10), GETDATE())   -- 02 6 2018 
  SELECT CONVERT(VARCHAR(10), GETDATE(), 126)   -- 2018-02-06
  SELECT CONVERT(VARCHAR(7), GETDATE(), 126)   -- 2018-02



  당월 증액한 사람 => 관리기록과 비교