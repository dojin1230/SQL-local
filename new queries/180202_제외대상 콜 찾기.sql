
-- 제외대상 콜 찾기 --
-- 노멀인데 재시작 콜 진행중인것 찾기 --

SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 = 'normal') D
ON H.회원번호 = D.회원번호
WHERE
(H.제목 LIKE '%RA%'
OR H.기록분류 LIKE '%재시작%')
AND H.처리진행사항 LIKE '%진행'
AND D.회원번호 IS NOT NULL