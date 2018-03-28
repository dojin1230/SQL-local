-- 관리기록이 ~거절(해지)인데 캔슬 기록이 없거나 캔슬 상태가 아닌 회원 -- (작동안하는듯)

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
  (SELECT *
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
  WHERE 기록분류 = 'cancellation') H2
ON H.회원번호 = H2.회원번호
LEFT JOIN
  (SELECT 회원번호, 회원상태
  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
  WHERE 회원상태 = 'canceled') D
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 LIKE '%해지%'
  AND CONVERT(varchar(10),H.참고일) BETWEEN CONVERT(DATE, '2018-01-01') AND CONVERT(DATE, GETDATE() - 2)  -- 참고일 이틀 지난 기록 (2018년 이전 제외)
  AND H2.회원번호 IS NULL
  AND D.회원번호 IS NULL