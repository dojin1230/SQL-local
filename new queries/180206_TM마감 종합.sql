--TM 마감 종합 (따로 작성한 쿼리들도 모으기)

--1. 신용카드 - 변경동의: 최근승인 확인
--2. 증액 - 증액성공: 증액 확인
--3. 거절(해지): 해지 확인 (혹은 캔슬 기록)
--4. 재시작동의: 노멀 확인/결제정보 신규등록 or 증빙자료등록 확인
--5. 재개동의: 노멀 확인
--6. 결제실패 - 결번 등/최근납부 정보: 프리징 확인

-- 1. 통성-변경동의 - 최근승인 확인 --


SELECT H.*
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
(SELECT 회원번호, 승인일
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드승인정보
WHERE CONVERT(DATE,승인일) >= CONVERT(DATE,GETDATE() - 3)) CA
ON H.회원번호 = CA.회원번호
WHERE
기록분류상세 IN ('통성-변경동의')
AND CONVERT(DATE,참고일) >= CONVERT(DATE,GETDATE() - 3)
AND CA.회원번호 IS NULL




-- 당월 증액 명단 --


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


-- 2. 증액 성공 했는데 증액자 명단에 없는 회원 --

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
  AND T1.시작년월 >= CONVERT(VARCHAR(7), GETDATE()-30, 126)
  AND T2.ROWN = 2) T3
ON H.회원번호 = T3.회원번호
WHERE 기록분류상세 = '통성-증액성공'
AND 참고일 >= CONVERT(DATE,GETDATE() - 4)
AND T3.회원번호 IS NULL


-- 3. 관리기록이 ~거절(해지)인데 캔슬 기록이 없는 회원 --

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT *
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	 WHERE 기록분류 = 'cancellation'
	 AND 참고일 >= CONVERT(DATE, GETDATE()-45)
	 ) H2
ON H.회원번호 = H2.회원번호
WHERE H.기록분류상세 LIKE '%(해지)'
  AND CONVERT(varchar(10),H.참고일) BETWEEN CONVERT(DATE, GETDATE()-45) AND CONVERT(DATE, GETDATE() - 2)  -- 참고일 45일 이내 이틀 지난 기록 
  AND H2.회원번호 IS NULL



--4. 재시작동의: 노멀 확인

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE 회원상태 = 'Normal') D	 
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 LIKE '%재시작동의'
	AND 참고일 >= CONVERT(DATE, GETDATE()-5)
	AND D.회원번호 IS NULL

--(추가) 재시작동의 결제정보 신규등록 or 증빙자료등록 확인

--5. 재개동의: 노멀 확인
SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE 회원상태 = 'Normal') D	 
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 LIKE '%재개동의'
	AND 참고일 >= CONVERT(DATE, GETDATE()-5)
	AND D.회원번호 IS NULL

	
--6. 결제실패 - 결번 등/최근납부 정보: 프리징 확인 (추가필요)

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 H
LEFT JOIN
	(SELECT 회원번호
	 FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
	 WHERE 회원상태 = 'Freezing') D	 
ON H.회원번호 = D.회원번호
WHERE H.기록분류상세 IN ('결번', '변경거절')
	AND H.기록분류 LIKE '%결제실패%'
	AND 참고일 >= CONVERT(DATE, GETDATE()-5)
	AND D.회원번호 IS NULL
