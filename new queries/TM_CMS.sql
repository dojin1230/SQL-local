-- CMS 증빙콜 대상 -- ///감사콜 할당 후 실행///

SELECT
	S.회원번호, S.CMS상태, S.CMS증빙자료등록필요, S.총납부건수, S.최종납부년월, S.가입일, CA.신청일, CA.처리결과, CA.결과메세지
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 S
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 in ('TM_CMS증빙', 'TM_결제실패_정기_정보오류')
		AND 처리진행사항 != 'SK-완료') TC
ON
	S.회원번호 = TC.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류 ='TM_감사'
		AND 기록일시 >= CONVERT(varchar(10), DATEADD(week, -3, GETDATE()), 126)) TT
ON
	S.회원번호 = TT.회원번호
LEFT JOIN
	(SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록 
	WHERE
		기록분류상세 = '결번') N
ON
	S.회원번호 = N.회원번호
LEFT JOIN
	(
	SELECT
		회원번호, MAX(신청일) AS 최근신청일
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보
	GROUP BY
		회원번호) A 
ON
	S.회원번호 = A.회원번호
LEFT JOIN
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_CMS승인정보 CA
ON
	A.회원번호 = CA.회원번호 AND A.최근신청일 = CA.신청일
WHERE
	((S.CMS상태 IN ('신규실패','수정실패') AND S.CARD상태 !='승인완료') OR S.CMS증빙자료등록필요='Y')
	AND S.회원상태='NORMAL'
	AND S.최초등록구분='정기'
	AND S.납부방법 IS NOT NULL
	AND S.가입일 < CONVERT(varchar(10), DATEADD(day, -3, GETDATE()), 126)
	AND TC.회원번호 IS NULL			-- CMS증빙콜이나 결제실패콜 진행 중이지 않은 경우
	AND TT.회원번호 IS NULL			-- 감사콜 진행 중이지 않은 경우
	AND N.회원번호 IS NULL			-- 결번 기록이 없는 경우
	--AND CA.결과메세지 IS NOT NULL	-- 처리실패 메시지가 있는 경우
ORDER BY 1 DESC

--select *
--FROM
--	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보
--where 회원번호='82050200'

