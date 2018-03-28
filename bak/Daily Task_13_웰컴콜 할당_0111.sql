-- 웰컴콜 할당 --

-- 제외조건 --
DROP TABLE IF EXISTS #ex
SELECT 
	H.회원번호
INTO 
	#ex
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AS H		-- History
WHERE 
	(H.[기록분류] LIKE 'TM_감사%')						-- 감사콜 기록 있는 후원자
	OR
	(H.[기록분류상세] = '결번')					-- 결번
	OR
	(H.[기록구분2] LIKE '%1%')						-- 후원자반응 '1.통화거부/강한불만'


-- Welcome 01 --
DROP TABLE IF EXISTS #wel01
SELECT
	D.회원번호, D.납부방법, D.CMS상태, D.카드사, D.CARD상태, D.가입경로, D.회원상태, D.소속, D.휴대전화번호,
	CASE 
		WHEN [D].[집전화번호] IS NOT NULL 
			OR [D].[직장전화번호] IS NOT NULL 
			OR [D].[휴대전화번호]='유' THEN '1'
		ELSE '0'
	END AS 연락처유무,																-- 전화번호 하나라도 있으면 '1'
	CASE
		WHEN [D].납부방법='CMS'
			AND [D].CMS상태 IN ('신규실패','수정실패','') THEN '인증실패/녹취대상'
		WHEN [D].납부방법='CMS' 
			AND [D].CMS상태 = '신규대기'
			AND [D].CMS증빙자료등록필요='Y' THEN '녹취대상'
		WHEN [D].납부방법='신용카드' 
			AND [D].CARD상태 IN ('승인대기','') THEN '인증실패'
		ELSE ''
	END AS 인증여부,																-- 인증실패여부/녹취대상여부 입력
	CASE
		WHEN D.가입경로='거리모집' 
			AND [D].[납부방법]='CMS'
			AND [D].[CMS상태] IN ('신규완료','신규실패','수정완료','수정실패','') THEN '1' -- 거리모집: CMS결과 나옴
		WHEN D.가입경로='거리모집' 
			AND [D].[납부방법]='신용카드'
			AND [D].[CARD상태] IN ('승인대기','승인완료','') THEN '1'						-- 거리모집: 신용카드
		--WHEN D.가입경로 IN ('Lead Conversion','전화')
		--	AND [D].[납부방법]='CMS'
		--	AND [D].[CMS상태] IN ('신규실패','수정실패','') THEN '1'						-- 전화/LC: CMS실패한 경우
		--WHEN D.가입경로 IN ('Lead Conversion','전화')
		--	AND [D].[납부방법]='신용카드'
		--	AND [D].[CARD상태] IN ('승인대기','') THEN '1'									-- 전화/LC: 신용카드
		WHEN D.가입경로='인터넷/홈페이지' 
			AND [D].[납부방법]='CMS'
			AND [D].[CMS상태] IN ('신규대기') THEN '1'										-- 인터넷: CMS 신규대기
		WHEN D.가입경로='인터넷/홈페이지' 
			AND [D].[납부방법]='신용카드'
			AND [D].[CARD상태] IN ('승인대기','승인완료') THEN '1'							-- 인터넷: 신용카드
		WHEN D.가입경로 IS NULL
			AND [D].[납부방법]='CMS'
			AND [D].[CMS상태] IN ('신규대기') THEN '1'										-- 가입경로 NULL (인터넷과 같음)
		WHEN D.가입경로 IS NULL
			AND [D].[납부방법]='신용카드'
			AND [D].[CARD상태] IN ('승인대기','승인완료','') THEN '1'						-- 가입경로 NULL (인터넷과 같음)
		ELSE '0'
	END AS 채널별콜대상구분,																-- 가입경로별로 콜 대상이면 '1'
	D.최초입력일
INTO
	#wel01
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] AS D		-- Donors Information
LEFT JOIN 
	#ex
ON D.회원번호 = #ex.회원번호

WHERE 
D.회원상태 Not In ('Canceled','Other')														-- 회원상태 Cancel 및 Other 제외
And ((IIf(D.집전화번호 Is Not Null,1,0)+IIf(D.직장전화번호 Is Not Null,1,0)+IIf(D.휴대전화번호='유',1,0))>0) -- 전화번호가 있는 경우만 선택
And ((D.가입일)>='2017-01-01')																-- 2017년 이후 가입자 (수정 필요한지 확인)
And ((D.최초등록구분)='정기')																-- 최초등록 정기
And ((D.등록구분)<>'외국인')																-- 외국인 제외
And ((#ex.회원번호) Is Null);																-- 제외조건 적용 (감사콜,결번,후원자반응1)

-- Welcome 02 --
DROP TABLE IF EXISTS #wel02
SELECT 
	#wel01.회원번호, #wel01.인증여부 AS 내용, #wel01.가입경로, #wel01.소속, 
	iif(#wel01.납부방법='CMS',#wel01.CMS상태, iif(#wel01.납부방법='신용카드',#wel01.CARD상태,null)) AS 납부방법상태, 
	#wel01.회원상태, 
	CONVERT(DATE,#wel01.최초입력일) AS 최초입력일
INTO 
	#wel02
FROM 
	#wel01
WHERE
	#wel01.채널별콜대상구분=1																-- 위 쿼리의 콜대상자 적용
ORDER BY
	내용 desc

-- 아래 3가지 쿼리에 나온 결과를 이용 --

-- 웰컴 대상자 -- 관리기록 입력
SELECT * 
FROM #wel02
ORDER BY 내용

-- 고액 후원자 추출 -- 해당자 관리기록 수정하여 리텐션팀으로 전달 (SK-진행->IH지연, 제목 W.CALL_WV->W.CALL)
SELECT *, '리텐션팀 전달'
FROM #wel02
LEFT JOIN (
	SELECT *
	FROM [MRMRT].[그린피스동아시아서울사무소0868].dbo.UV_GP_후원약정금액정보
	WHERE 금액 >= 100000													-- 약정금액 100000 이상
		AND 상태 != '종료'													-- 진행/대기/일시중지 상태
		AND 종료년월 = ''													-- 일시후원금액(종료년월 존재)이 아님
		AND CONVERT(DATE,신청일) >= CONVERT(DATE,GETDATE()-90)) PL			-- 해당납부금액 신청일이 90일 이내				
ON #wel02.회원번호 = PL.회원번호
WHERE PL.회원번호 IS NOT NULL

-- 캔슬 신청 및 처리자 -- 해당자 관리기록 제외처리
SELECT *, '제외처리 대상자'
FROM #wel02
LEFT JOIN (
	SELECT *
	FROM [MRMRT].[그린피스동아시아서울사무소0868].dbo.UV_GP_관리기록
	WHERE
		기록분류 = 'Cancellation') H
ON #wel02.회원번호 = H.회원번호
WHERE H.회원번호 IS NOT NULL