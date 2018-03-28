SELECT A.회원번호, 납부건수, 총금액
FROM
  (SELECT 회원번호, COUNT(납부일) 납부건수, SUM(납부금액) 총금액
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
  WHERE 정기수시 = '정기'
    AND 환불상태 = ''
    AND 납부금액 >= 10000
  GROUP BY 회원번호) A
WHERE
  A.납부건수 >= 4
  AND A.총금액 >= 40000

--최근 7개월 이내에 후원금 증액 혹은 감액
SELECT 회원번호
FROM
  (SELECT 회원번호, AVG(납부금액) 평균금액, MIN(납부금액) 최소금액
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
  WHERE 납부일 >= CONVERT(VARCHAR(10), DATEADD(MONTH, -7, GETDATE()), 126)
    AND 정기수시 = '정기'
  GROUP BY 회원번호) C
WHERE C.평균금액 != C.최소금액 
