

-- IH 진행건 처리 --

--기록분류상세: SS-canceled / Canceled -> 캔슬 처리 확인
--기록분류상세: SS-DGamount -> 감액 확인
--기록분류상세: SS-tempstop -> 일시중지 확인
--제목: I카드변경 -> 변경확인
--제목: I계좌변경 -> 변경확인
--제목: I금액변경 -> 변경확인
--기록분류상세: 자발_Unfreezeing -> 노멀 및 결제정보 변경확인
--기록분류상세: 후원금액downgrade -> 감액 확인
--기록분류상세: 후원금액upgrade -> 증액 확인


-- 캔슬확인 --

SELECT H.*, D.회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 != 'canceled') D
ON H.회원번호 = D.회원번호
WHERE 
기록분류상세 IN ('SS-Canceled', 'Canceled')
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 5)
AND D.회원번호 IS NOT NULL


-- 감액확인 --






-- 제목: I카드변경 -> 변경확인 --

SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 승인일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보
WHERE CONVERT(DATE,승인일) >= CONVERT(DATE,GETDATE() - 3)) CA
ON H.회원번호 = CA.회원번호
WHERE
제목 LIKE '%카드변경'
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 3)
AND CA.회원번호 IS NULL


-- 제목: 중지요청 -> 변경확인 --

SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 = 'stop_tmp') D
ON H.회원번호 = D.회원번호
WHERE
(H.제목 LIKE '%중지%'
OR H.기록분류상세 LIKE '%중지%'   -- 추후테스트
OR H.기록분류 LIKE '%중지%')	-- 추후테스트
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 3)
AND D.회원번호 IS NULL


