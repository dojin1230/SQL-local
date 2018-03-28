

-- IH 진행건 처리 --

--IH-진행건 마감
--1. 기록분류상세: SS-canceled / Canceled -> 캔슬 처리 확인
--2. 기록분류상세: SS-DGamount -> 감액 확인
--3. 기록분류상세: SS-tempstop -> 일시중지 확인
--4. 제목: I카드변경 -> 변경확인
--5. 제목: I계좌변경 -> 변경확인
--6. 제목: I금액변경 -> 변경확인
--7. 기록분류상세: 자발_Unfreezeing -> 노멀 및 결제정보 변경확인
--8. 기록분류상세: 후원금액downgrade -> 감액 확인
--9. 기록분류상세: 후원금액upgrade -> 증액 확인

/*
증액/감액/금액변경에서 일시후원금액을 제외하는 방법으로 시작년월=종료년월인 항목들을 빼고 계산하는데 보다 정확한 방법 개발 필요
*/

--1. 기록분류상세: SS-canceled / Canceled -> 캔슬 처리 확인

SELECT H.*, D.회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 회원상태
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
WHERE 회원상태 = 'canceled') D
ON H.회원번호 = D.회원번호
WHERE
기록분류상세 IN ('SS-Canceled', 'Canceled')
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 5)
AND D.회원번호 IS NULL


-- 최근감액명단 --

--SELECT *
--FROM
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  LEFT JOIN
--  (SELECT 회원번호
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--  GROUP BY 회원번호
--  HAVING COUNT(회원번호) > 1) B
--  ON A.회원번호 = B.회원번호
--  WHERE A.시작년월 != A.종료년월
--  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
--  ) T1
--CROSS JOIN
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  LEFT JOIN
--  (SELECT 회원번호
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--  GROUP BY 회원번호
--  HAVING COUNT(회원번호) > 1) B
--  ON A.회원번호 = B.회원번호
--  WHERE A.시작년월 != A.종료년월
--  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
--  ) T2
--WHERE
--  T1.회원번호 = T2.회원번호
--  AND T1.일련번호 > T2.일련번호
--  AND T1.금액 < T2.금액
--  AND T1.ROWN = 1
--  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
--  AND T2.ROWN = 2

-- 2. 기록분류상세: SS-DGamount -> 감액 확인 (결과값에 감액을 했는데도 나오는 경우: 이전 납부기록의 시작년월/종료년월이 같을 때)

SELECT H.*, DG.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT T1.회원번호, T1.납부여부, T1.상태 AS 상태1, T1.신청일 AS 신청일1, T1.금액 AS 금액1, T2.상태 AS 상태2, T2.신청일 AS 신청일2, T2.금액 AS 금액2
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
	  AND T1.금액 < T2.금액
	  AND T1.ROWN = 1
	  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
	  AND T2.ROWN = 2
	  ) DG
ON H.회원번호 = DG.회원번호
WHERE
기록분류상세 LIKE '%DG%'
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 5)
AND DG.회원번호 IS NULL






--3. 기록분류상세: SS-tempstop -> 일시중지 확인

SELECT H.*, D.회원상태
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



--4. 제목: I카드변경 -> 변경확인

SELECT H.*, CA.승인일
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


--5. 제목: I계좌변경 -> 변경확인


SELECT H.*, CH.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT *
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력
	WHERE 변경항목 = '은행'
	AND CONVERT(DATE,변경일시) >= CONVERT(DATE,GETDATE()-3)
	) CH
ON H.회원번호 = CH.회원번호
WHERE
제목 LIKE '%계좌변경'
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 3)
AND CH.회원번호 IS NULL

--6. 제목: I금액변경 -> 변경확인

-- 최근금액변경명단 --

--SELECT T1.회원번호
--FROM
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  LEFT JOIN
--  (SELECT 회원번호
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--  GROUP BY 회원번호
--  HAVING COUNT(회원번호) > 1) B
--  ON A.회원번호 = B.회원번호
--  WHERE A.시작년월 != A.종료년월
--  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
--  ) T1
--CROSS JOIN
--  (
--  SELECT ROW_NUMBER() OVER(PARTITION BY 회원번호 ORDER BY 일련번호 DESC) AS ROWN, *
--  FROM
--  (SELECT A.*
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보 A
--  LEFT JOIN
--  (SELECT 회원번호
--  FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원약정금액정보
--  GROUP BY 회원번호
--  HAVING COUNT(회원번호) > 1) B
--  ON A.회원번호 = B.회원번호
--  WHERE A.시작년월 != A.종료년월
--  AND B.회원번호 IS NOT NULL) C -- 약정 금액 시작년월 종료년월 다른건들 중 납부건수 둘 이상인 회원의 약정
--  ) T2
--WHERE
--  T1.회원번호 = T2.회원번호
--  AND T1.일련번호 > T2.일련번호
--  AND T1.금액 != T2.금액
--  AND T1.ROWN = 1
--  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
--  AND T2.ROWN = 2

SELECT H.*, TMP1.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(
	SELECT T1.회원번호
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
	  AND T1.금액 != T2.금액
	  AND T1.ROWN = 1
	  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
	  AND T2.ROWN = 2
	) TMP1
ON H.회원번호 = TMP1.회원번호
WHERE
제목 LIKE '%금액변경'
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 5)
AND TMP1.회원번호 IS NULL

--7. 기록분류상세: 자발_Unfreezing -> 노멀 및 결제정보 변경확인

SELECT H.*, D.회원상태, CH.변경항목
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호, 회원상태
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	WHERE 회원상태 = 'Normal'
	) D
ON H.회원번호 = D.회원번호
LEFT JOIN
	(SELECT 회원번호, 변경항목
	FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력
	WHERE 변경항목 IN ('계좌번호', '은행', '납부방법')
    AND CONVERT(DATE,변경일시) >= CONVERT(DATE,GETDATE()-3)
  ) CH
ON H.회원번호 = CH.회원번호
WHERE 기록분류상세 = '자발_Unfreezing'
	AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE()-3)
	AND (D.회원번호 IS NULL
	OR CH.회원번호 IS NULL)


--8. 기록분류상세: 후원금액downgrade -> 감액 확인

SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT T1.회원번호
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
	  AND T1.금액 < T2.금액
	  AND T1.ROWN = 1
	  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
	  AND T2.ROWN = 2
	) TMP1
ON H.회원번호 = TMP1.회원번호
WHERE 기록분류상세 = '후원금액downgrade'
	AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE()-3)
	AND TMP1.회원번호 IS NULL

--9. 기록분류상세: 후원금액upgrade -> 증액 확인
SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT T1.회원번호
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
	  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)	-- 시작년월은 여기서 수정
	  AND T2.ROWN = 2
	) TMP1
ON H.회원번호 = TMP1.회원번호
WHERE 기록분류상세 = '후원금액upgrade'
	AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE()-3)
	AND TMP1.회원번호 IS NULL


-- 제목 분류 및 카테고리에 들어가지 않는 것 확인 --
-- 예: I금액변경 등



-- 제목: 중지요청 -> 변경확인 --

SELECT H.*, D.회원상태
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


-- 기타 변경 확인 --
-- 제목: I명의변경 --


SELECT H.*, CH.변경항목
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 변경항목
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_변경이력
WHERE 변경항목 = '성명'
	AND CONVERT(DATE,변경일시) >= CONVERT(DATE,GETDATE() - 3)
) CH
ON H.회원번호 = CH.회원번호
WHERE
	H.제목 LIKE '%명의변경'
	AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 3)
	AND CH.회원번호 IS NULL
