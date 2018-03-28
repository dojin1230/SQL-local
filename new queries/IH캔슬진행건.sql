

-- 최근 캔슬기록 있지만 캔슬상태 아닌 회원 (IH-진행건 캔슬 확인)--

SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 != 'canceled') D
ON H.회원번호 = D.회원번호
WHERE
기록분류상세 IN ('SS-Canceled', 'Canceled')
AND 참고일 >= CONVERT(VARCHAR(10),GETDATE() - 4)
AND D.회원번호 IS NOT NULL




SELECT H.*, D.회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 != 'canceled') D
ON H.회원번호 = D.회원번호
WHERE
기록분류상세 IN ('SS-Canceled', 'Canceled')
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 4)
AND D.회원번호 IS NULL
