SELECT
	D.회원번호,
	CASE
	WHEN 납부방법 = 'CMS' AND CMS상태='신규실패' THEN '인증실패/녹취대상'
	WHEN 납부방법 = 'CMS' AND CMS상태='신규대기' AND CMS증빙자료등록필요='Y' THEN '녹취대상'
	ELSE ''
	END AS 내용,
	CONVERT(DATE,GETDATE()) AS 일자,
	'TM_감사-미처리' AS [기록분류/상세분류],
	CASE
	WHEN D.납부금액 < 100000 THEN 'SK-진행'
	ELSE 'IH-지연'
	END AS 구분1,
	CASE
	WHEN D.납부금액 < 100000 THEN 'W.CALL_WV'
	ELSE 'W.CALL'
	END AS 제목,
	CASE
	WHEN 납부방법 = 'CMS' THEN D.CMS상태
	WHEN 납부방법 = '신용카드' THEN D.CARD상태
	END AS [CMS/카드상태],
	D.납부방법,
	D.가입경로,
	D.가입일,
	D.CMS증빙자료등록필요,
	D.납부금액
FROM
	MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_후원자정보 D
LEFT JOIN
	(
	SELECT
		회원번호
	FROM
		MRMRT.그린피스동아시아서울사무소0868.dbo.UV_GP_관리기록
	WHERE
		기록분류 like 'TM_감사%'
		OR 기록분류 = 'Cancellation'
	) H
ON
	D.회원번호 = H.회원번호
WHERE
	H.회원번호 is null											-- 감사/감사3개월/감사6개월 콜 받은 사람, 캔슬 기록 있는 사람 제외
	AND D.가입경로 in ('인터넷/홈페이지','거리모집')				-- 가입경로가 Web이나 DDC인 사람들만
	AND D.최초등록구분 = '정기'
	AND D.휴대전화번호 = '유'
	AND D.등록구분 != '외국인'
	AND D.회원상태 not in ('canceled', 'other')					-- 회원 상태
	AND D.가입일 >= CONVERT(varchar(10), '2018-01-01', 126)		-- 2018년 가입자부터
	AND (
		(D.CMS상태 = '신규대기' AND D.CMS증빙자료등록필요 = 'Y')
		OR (D.CMS상태 = '수정대기' AND D.CMS증빙자료등록필요 = 'Y')
		OR (D.CMS상태 = '신규완료')
		OR (D.CMS상태 = '수정완료')
		OR (D.납부방법 = '신용카드')
		)
