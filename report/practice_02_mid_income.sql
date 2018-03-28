use report
go

-- 0-0. 월초 작업을 통해 upgrade/downgrade 후원자들을 가려낸다: 10일 결제일만 지나면 할 수 있는 작업. 16일까지 기다릴 필요 없음.
-- 0-1. 이번달 납부금액이 그 직전 납부금액보다 큰 후원자를 뽑아 upgrade 테이블을 업데이트 한다.

INSERT INTO REPORT.DBO.upgrade_monthly
SELECT UP.회원번호, UP.최근납부금액, UP.직전납부금액, UP.차액,
       YEAR(MP.최근납부일) AS UpgradeYear
       MONTH(MP.최근납부일) AS UpgradeMonth
FROM
    (SELECT 회원번호, 최근납부금액, 직전납부금액, 최근납부금액 - 직전납부금액 AS 차액
     FROM
         (SELECT 회원번호,
                 SUM(CASE WHEN 최근납부일순서 = 1 THEN 납부금액 END) AS 최근납부금액,
                 SUM(CASE WHEN 최근납부일순서 = 2 THEN 납부금액 END) AS 직전납부금액
          FROM
              (SELECT A.회원번호, RANK() OVER (PARTITION BY PR.회원번호 ORDER BY PR.납부일 DESC) AS 최근납부일순서, PR.납부금액
               FROM
                   (SELECT 회원번호
                    FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
                    WHERE 정기수시 = '정기'
                          AND 납부일 >= DATEADD(MM, DATEDIFF(MM, 0, GETDATE()), 0)
                          AND 납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))
                   ) A -- 이번달 결제(정기)한 사람
               LEFT JOIN MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_결제정보 PR
               ON A.회원번호 = PR.회원번호
               WHERE PR.정기수시 = '정기'
                     AND PR.환불상태 = ''
                     AND PR.납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))
              ) B -- 이번달 결제(정기)한 사람들의 모든 정기 결제정보
           GROUP BY 회원번호
         ) C  -- 회원번호별로 묶어서 최근/직전 납부금액
     WHERE 직전납부금액 IS NOT NULL
   ) UP
LEFT JOIN (SELECT 회원번호, MAX(납부일) AS 최근납부일
           FROM MRMRT.그린피스동아시아서울사무소0868.DBO.UV_GP_결제정보
           WHERE 정기수시 = '정기'
                 AND 환불상태 = ''
                 AND 납부일 < CONVERT(DATE, CONCAT(CONVERT(VARCHAR(8), GETDATE(), 126), '16'))
           GROUP BY 회원번호
          ) MP
ON UP.회원번호 = MP.회원번호
WHERE UP.차액 > 0

-- 0-2. downgrade 테이블 업데이트 (위와 거의 동일)

-- 0-3. Acquired Donor 테이블 업데이트 -- 15일 이후 작업
-- 0-3-1. New Acquired Donor for this month
