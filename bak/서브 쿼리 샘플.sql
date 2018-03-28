SELECT 
  Year(출금일) AS [Debit year], 
  Month(출금일) AS [Debit month], 
  출금일 AS [Debit date], 
  회원코드 AS Constituent_id, 
  신청금액 AS Amount, 
  CASE
  WHEN 처리결과 like '%실패%' THEN 0
  ELSE 1
  END AS Response, 
  [Payment method]
 FROM
 (
  SELECT
   출금일,
   회원코드,
   신청금액,
   처리결과,
   'CMS' as [Payment method]
  FROM 
   MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
  UNION ALL
  SELECT 
   [출금일],
   [회원코드], 
   [신청금액], 
   [결과], 
   'CRD' as [Payment method]
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과
  ) PR
 WHERE
  출금일 >= CONVERT(varchar(10), '2017-10-01', 126) 
  AND 출금일 < CONVERT(varchar(10), '2017-11-01', 126)