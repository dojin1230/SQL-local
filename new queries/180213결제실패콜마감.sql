-- 1. 변경거절(일시중지): 일시중지 확인
-- 확인후 목록에서 제거
SELECT H.회원번호, H.기록일시, H.기록분류상세, D.회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT 회원번호, 회원상태
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
     WHERE 회원상태 = 'stop_tmp'
    ) D
ON H.회원번호 = D.회원번호
WHERE H.기록분류 = 'TM_결제실패_정기_정보오류'
    AND H.기록분류상세  = '통성-변경거절(일시중지)'
    AND CONVERT(DATE,H.기록일시) >= CONVERT(DATE,GETDATE()-20) -- 추후 한달로 변경


-- 2. 변경거절(해지): 캔슬 기록 확인 - 세이브 된 경우 결제정보 재입력 확인
-- 확인후 목록에서 제거
SELECT H.회원번호, H.기록일시, H.기록분류상세, H2.기록일시, H2.기록분류상세, H2.참고일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT 회원번호, 기록일시, 기록분류상세, 참고일
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
     WHERE 기록분류 = 'cancellation'
        AND CONVERT(DATE,기록일시) >= CONVERT(DATE,GETDATE()-20)
    ) H2
ON H.회원번호 = H2.회원번호
WHERE H.기록분류 = 'TM_결제실패_정기_정보오류'
    AND H.기록분류상세  = '통성-변경거절(해지)'
    AND CONVERT(DATE,H.기록일시) >= CONVERT(DATE,GETDATE()-20) -- 추후 한달로 변경

-- 3. 변경동의인데 결제 없었던 사람 확인 => 프리징 대상
-- 실패 사유 확인후 프리징걸고(잔고 관련이면 그대로 둠) 나머지 변경동의는 목록에서 제거
SELECT H.회원번호, H.기록일시, H.기록분류상세, PR.납부일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT *
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
     WHERE 납부일 >= CONVERT(DATE,GETDATE()-5)
   ) PR
ON H.회원번호 = PR.회원번호
WHERE H.기록분류 = 'TM_결제실패_정기_정보오류'
    AND CONVERT(DATE,H.기록일시) >= CONVERT(DATE,GETDATE()-20) -- 추후 한달로 변경
	AND PR.납부일 IS NULL
	AND H.기록분류상세 = '통성-변경동의'



-- 4. 변경동의 아닌데 결제성공한 사람들 프리징 대상에서 제외

SELECT H.회원번호, H.기록일시, H.기록분류상세, PR.납부일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT *
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
     WHERE 납부일 >= CONVERT(DATE,GETDATE()-5)
   ) PR
ON H.회원번호 = PR.회원번호
WHERE H.기록분류 = 'TM_결제실패_정기_정보오류'
    AND CONVERT(DATE,H.기록일시) >= CONVERT(DATE,GETDATE()-20) -- 추후 한달로 변경
	AND PR.납부일 IS NOT NULL
	AND H.기록분류상세 != '통성-변경동의'

-- 5. 정보전송시점 이후로 신용카드 승인된 사람들 프리징 대상에서 제외

SELECT H.회원번호, H.기록일시, H.기록분류상세, CA.승인일시
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
    (SELECT *
     FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보
     WHERE 승인일시 >= '2018-02-09 17:04'	-- 신용카드-정기납부정보-납부신청일시값 입력
   ) CA
ON H.회원번호 = CA.회원번호
WHERE H.기록분류 = 'TM_결제실패_정기_정보오류'
    AND CONVERT(DATE,H.기록일시) >= CONVERT(DATE,GETDATE()-20) -- 추후 한달로 변경
	  AND CA.회원번호 IS NOT NULL


--6. 나머지 프리징
