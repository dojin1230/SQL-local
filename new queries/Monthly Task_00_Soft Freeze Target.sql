-- 소프트 프리징 타게팅 --


SELECT
	DD.회원번호, COUNT(DD.회원번호)
FROM
	(SELECT D.회원번호, D.회원상태
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
	INNER JOIN
		(SELECT 출금일, 회원코드, 신청금액,
			CASE
				WHEN 처리결과 = '출금완료' THEN '성공'
				ELSE '실패'
			END AS 결과,
			결과메세지,
			CASE
				WHEN 결과메세지 LIKE '%잔액%' THEN 'SOFT'
				WHEN 결과메세지 LIKE '%잔고%' THEN 'SOFT'
				WHEN 결과메세지 LIKE '%한도%' THEN 'SOFT'
				WHEN 처리결과 = '출금완료' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CMS' AS pymt_mtd
		FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS결제결과
		UNION ALL
		SELECT 출금일, 회원코드, 신청금액, 결과, 실패사유,
			CASE
				WHEN 실패사유 LIKE '%잔액%' THEN 'SOFT'
				WHEN 실패사유 LIKE '%잔고%' THEN 'SOFT'
				WHEN 실패사유 LIKE '%한도%' THEN 'SOFT'
				WHEN 결과 = '성공' THEN NULL
				ELSE 'HARD'
			END AS TYPE,
			'CRD' AS pymt_mtd
		FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_신용카드결제결과) BR_CR
	ON D.회원번호 = BR_CR.회원코드 		-- 후원자정보에 CMS 및 카드 결제결과 조인 (기존쿼리대로 이너조인 되어있으나 레프트 조인도 무방)
	LEFT JOIN
		(SELECT 일련번호, ID, 회원번호, 기록일시, 기록분류, 기록분류상세, 참고일, 처리진행사항, 제목, 최초입력자, 기록구분2
		FROM MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
		WHERE
					기록분류 = 'TM_후원재개_잔액부족'
					AND 기록분류상세 = '통성-재개동의'
					AND CONVERT(VARCHAR(7),참고일) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -3, GETDATE()), 126)) H
	ON D.회원번호 = H.회원번호    	-- 후원자정보에 관리기록 조인
	WHERE (CONVERT(VARCHAR(7),D.최종납부년월) < CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)
		OR D.최종납부년월 IS NULL)  -- 마지막으로 납부한 달이 4개월 이전이거나 납부기록이 없는 경우만 추출 (예: 1월초 작업시 최종납부년월이 전년도 8월 이전)
		AND BR_CR.결과 = '실패'			-- 카드 및 CMS 결제결과 출금 실패한 경우
		AND BR_CR.TYPE = 'SOFT'			-- 실패사유가 잔액/잔고/한도 문제인 경우
		AND CONVERT(VARCHAR(7),BR_CR.출금일) >= CONVERT(VARCHAR(7), DATEADD(MONTH, -4, GETDATE()), 126)  -- 결제결과 중 출금일이 4개월 이내인 경우만 선택
		AND H.회원번호 IS NULL			-- 3개월 이내에 잔액부족 콜을 받고 동의한 경우 제외
	) DD
GROUP BY DD.회원번호, DD.회원상태
HAVING
	COUNT(DD.회원번호) >= 8
	AND DD.회원상태 = 'normal'