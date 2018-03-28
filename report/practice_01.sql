use [report]
go

-- 0. 저번달 mid-income 때 업데이트한 upgrade/downgrade 데이터 삭제

delete from
  report.dbo.upgrade_monthly

WHERE
  UpgradeMonth = MONTH(DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1,0))
GO

DELETE FROM
  report.dbo.downgrade_monthly
where
  DowngradeMonth = MONTH(DATEADD(MM,DATEDIFF(MM,0,GETDATE())-1,0)))
GO

-- 1. 저번달 납부금액이 그 직전 납부금액보다 큰 후원자를 뽑아 UPGRADE 테이블을 UPDATE한다.
INSERT INTO
  REPORT.DBO.upgrade_monthly
SELECT
  UP.회원번호, UP.최근납부금액, UP.직전납부금액, UP.차액,
  YEAR(MP.최근납부일) AS UpgradeYear,
  MONTH(MP.최근납부일) AS UpgradeMonth   --꼭 mp테이블을 만들어서 넣을 필요는 없어보임 (모두 지난달이 최근납부월임)
from
  (SELECT
    회원번호, 최근납부금액, 직전납부금액, 최근납부금액 - 직전납부금액 AS 차액
    from
      (SELECT
        회원번호,
        SUM(CASE WHEN 최근납부일순서 = 1 THEN 납부금액 END) AS 최근납부금액,
        SUM(CASE WHEN 최근납부일순서 = 2 THEN 납부금액 END) AS 직전납부금액
        FROM
          (SELECT
            PR.회원번호, RANK() OVER (PARTITION BY PR.회원번호 ORDER BY PR.납부일 DESC) AS 최근납부일순서, PR.납부금액
          FROM
            (SELECT
              회원번호
              FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
              WHERE 정기수시 = '정기'
                AND 납부일 >= DATEADD(MM, DATEDIFF(MM, 0, GETDATE())-1, 0)
                AND 납부일 < DATEADD(MM, DATEDIFF(MM, 0, GETDATE()), 0)
            ) A -- 지난달 정기 납부한 회원들 번호만 추린다
          LEFT JOIN
            MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 PR
          ON A.회원번호 = PR.회원번호
          WHERE PR.정기수시 = '정기'
            AND PR.환불상태 = ''
            AND PR.납부일 < DATEADD(MM, DATEDIFF(MM,0,GETDATE()),0)
        ) B -- 추린 회원들의 환불되지 않은 정기 납부금액을 모두 가져온다.
        GROUP BY 회원번호
      ) C
    WHERE 직전납부금액 IS NOT null
  ) UP
  LEFT JOIN
    (SELECT 회원번호, MAX(납부일) AS 최근납부일
    FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보
    WHERE 정기수시 = '정기'
      AND 환불상태 = ''
      AND 납부일 < DATEADD(MM, DATEDIFF(MM, 0, GETDATE()),0)
    GROUP BY 회원번호
  ) MP -- 환불되지 않은 정기 납부건 중 회원별로 가장 최근 납부건만  (MOST FREQUENT PAYMENT?)
  ON UP.회원번호 = MP.회원번호
  WHERE UP.차액 > 0

-- 2. 저번달 납부금액이 그 직전 납부금액보다 적은 후원자를 뽑아 DOWNGRADE 테이블을 업데이트한다.
-- 이테이블은 UPGRADE 업데이트 쿼리와 동일하고 UP.차액만 < 0

-- 3. 저번달 UPGRADE 후원자들을 그룹에 할당한다.
SELECT UP.회원번호, 'UPGRADE_ACTUAL DONATION' AS 그룹명
FROM REPORT.DBO.upgrade_monthly UP
LEFT JOIN MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
ON UP.회원번호 = D.회원번호
WHERE UP.UpgradeMonth = MONTH(DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1,0)) -- 지난달에 업그레이드 했고
  AND D.회원상태 = 'Normal' -- 회원상태 노말


-- 4. 재시작 동의한 사람들 중 전월에 첫 납부를 한 후원자들을 그룹에 할당
SELECT A.회원번호, 'Reactivation_Actual donation' AS 그룹명
FROM
  (SELECT H.회원번호, MIN(PR.납부일) 첫결제일
   FROM
      (SELECT 회원번호, 참고일 AS 재가입일
       FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
       WHERE 기록분류 = 'TM_후원재시작' AND 기록분류상세 = '통성-재시작동의'
      ) H
       LEFT JOIN MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보 PR
       ON H.회원번호 = PR.회원번호
       WHERE PR.납부일 >= H.재가입일
       GROUP BY H.회원번호
  ) A
   LEFT JOIN MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
   ON A.회원번호 = D.회원번호
   WHERE A.첫결제일 >= CONVERT(DATE, DATEADD(MM, DATEDIFF(MM,0,GETDATE())-1, 0), 126)
         AND A.첫결제일 < CONVERT(DATE, DATEADD(MM, DATEDIFF(MM,0,GETDATE()), 0), 126)
         AND D.회원상태 = 'NORMAL'

-- 5. 소프트 프리징 타게팅
SELECT
  DD.회원번호,
  'Freezing-insufficient funds' AS [기록분류/상세분류],
  CONVERT(DATE, GETDATE(), 126) AS 일자,
  'IH-완료' AS 구분1,
  'F' AS 제목,
  CONVERT(DATE, GETDATE(), 126) AS 참고일,
  COUNT(DD.회원번호) AS 미납횟수
FROM
  (SELECT D.회원번호, D.회원상태
   FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
   INNER JOIN
     (SELECT 출금일, 회원코드, 신청금액,
        CASE
        WHEN 처리결과 = '출금완료' THEN '성공'
        ELSE '실패' END AS 결과,
        결과메세지,
        CASE
        WHEN 결과메세지 LIKE '%잔액%' THEN 'SOFT'
        WHEN 처리결과 = '출금완료' THEN NULL
        ELSE 'HARD' END AS TYPE,
        'CMS' AS pymt_mtd
      FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
      UNION ALL
      SELECT 출금일, 회원코드, 신청금액, 결과, 실패사유,
        CASE
        WHEN 실패사유 LIKE '%잔액%' THEN 'SOFT'
        WHEN 실패사유 LIKE '%잔고%' THEN 'SOFT'
        WHEN 실패사유 LIKE '%한도%' THEN 'SOFT'
        WHEN 결과 = '성공' THEN null
        ELSE 'HARD' END AS TYPE,
        'CRD' AS pymt_mtd
      FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_신용카드결제결과
     ) BR_CR
    ON D.회원번호 = BR_CR.회원코드
    LEFT JOIN
      (SELECT 일련번호, ID, 회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
       FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_관리기록
       WHERE 기록분류 = 'TM_후원재개_잔액부족'
             AND 기록분류상세 = '통성-재개동의'
             AND CONVERT(DATE,참고일) >= CONVERT(DATE, DATEADD(MONTH, -3, GETDATE()), 126)
      ) H
    ON D.회원번호 = H.회원번호
    WHERE (CONVERT(VARCHAR(7), D.최종납부년월) < CONVERT(VARCHAR(7),DATEADD(MONTH, -4, GETDATE()), 126)
           OR D.최종납부년월 IS NULL)
           AND BR_CR.결과 = '실패'
           AND BR_CR.TYPE = 'SOFT'
           AND CONVERT(VARCHAR(7),BR_CR.출금일) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
           AND H.회원번호 IS null
   ) DD
GROUP BY DD.회원번호, DD.회원상태
HAVING COUNT(DD.회원번호) >= 8 AND DD.회원상태 = 'NORMAL'

-- 정기납부가 종료된 회원들 CANCEL로 변경

SELECT *
FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원자정보 D
LEFT JOIN
  (SELECT *
   FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_후원약정금액정보
   WHERE 종료년월 >= SUBSTRING(CONVERT(VARCHAR(10), GETDATE(), 126), 1, 7)
         OR 상태 IN ('대기', '진행')
  ) PL
ON D.회원번호 = PL.회원번호
WHERE D.회원상태 = 'NORMAL'
      AND D.최초등록구분 = '정기'
      AND PL.회원번호 IS NULL
