-- 웰컴콜 할당 --


-- 제외조건 --
DROP TABLE IF EXISTS #ex
SELECT 
	MR.회원번호
INTO 
	#ex
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AS MR		-- Management Records
WHERE 
	(MR.[기록분류] = 'TM_감사')						-- 감사콜 기록 있는 후원자
	OR
	(MR.[기록분류상세] = '결번')					-- 결번
	OR
	(MR.[기록구분2] LIKE '%1%')						-- 후원자반응 '1.통화거부/강한불만'


-- Welcome 01 --
DROP TABLE IF EXISTS #wel01
SELECT
	DI.회원번호, DI.납부방법, DI.CMS상태, DI.카드사, DI.CARD상태, DI.가입경로, DI.회원상태, DI.소속, DI.휴대전화번호,
	CASE 
		WHEN [DI].[집전화번호] IS NOT NULL 
			OR [DI].[직장전화번호] IS NOT NULL 
			OR [DI].[휴대전화번호]='유' THEN '1'
		ELSE '0'
	END AS 연락처유무,																-- 전화번호 하나라도 있으면 '1'
	CASE
		WHEN [DI].납부방법='CMS'
			AND [DI].CMS상태 IN ('신규실패','수정실패','') THEN '인증실패/녹취대상'
		WHEN [DI].납부방법='CMS' 
			AND [DI].CMS상태 = '신규대기'
			AND [DI].CMS증빙자료등록필요='Y' THEN '녹취대상'
		WHEN [DI].납부방법='신용카드' 
			AND [DI].CARD상태 IN ('승인대기','') THEN '인증실패'
		ELSE NULL
	END AS 인증여부,																-- 인증실패여부/녹취대상여부 입력
	CASE
		WHEN DI.가입경로='거리모집' 
			AND [DI].[납부방법]='CMS'
			AND [DI].[CMS상태] IN ('신규완료','신규실패','수정완료','수정실패','') THEN '1' -- 거리모집: CMS결과 나옴
		WHEN DI.가입경로='거리모집' 
			AND [DI].[납부방법]='신용카드'
			AND [DI].[CARD상태] IN ('승인대기','승인완료','') THEN '1'						-- 거리모집: 신용카드
		WHEN DI.가입경로 IN ('Lead Conversion','전화')
			AND [DI].[납부방법]='CMS'
			AND [DI].[CMS상태] IN ('신규실패','수정실패','') THEN '1'						-- 전화/LC: CMS실패한 경우
		WHEN DI.가입경로 IN ('Lead Conversion','전화')
			AND [DI].[납부방법]='신용카드'
			AND [DI].[CARD상태] IN ('승인대기','') THEN '1'									-- 전화/LC: 신용카드
		WHEN DI.가입경로='인터넷/홈페이지' 
			AND [DI].[납부방법]='CMS'
			AND [DI].[CMS상태] IN ('신규대기') THEN '1'										-- 인터넷: CMS 신규대기
		WHEN DI.가입경로='인터넷/홈페이지' 
			AND [DI].[납부방법]='신용카드'
			AND [DI].[CARD상태] IN ('승인대기','승인완료') THEN '1'							-- 인터넷: 신용카드
		WHEN DI.가입경로 IS NULL
			AND [DI].[납부방법]='CMS'
			AND [DI].[CMS상태] IN ('신규대기') THEN '1'										-- 가입경로 NULL (인터넷과 같음)
		WHEN DI.가입경로 IS NULL
			AND [DI].[납부방법]='신용카드'
			AND [DI].[CARD상태] IN ('승인대기','승인완료','') THEN '1'						-- 가입경로 NULL (인터넷과 같음)
		ELSE '0'
	END AS 채널별콜대상구분,																-- 가입경로별로 콜 대상이면 '1'
	DI.최초입력일
INTO
	#wel01
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] AS DI		-- Donors Information
LEFT JOIN 
	#ex
ON DI.회원번호 = #ex.회원번호

WHERE 
DI.회원상태 Not In ('Canceled','Other')														-- 회원상태 Cancel 및 Other 제외
And ((IIf(DI.집전화번호 Is Not Null,1,0)+IIf(DI.직장전화번호 Is Not Null,1,0)+IIf(DI.휴대전화번호='유',1,0))>0) -- 전화번호가 있는 경우만 선택
And ((DI.가입일)>='2017-01-01')																-- 2017년 이후 가입자 (수정 필요한지 확인)
And ((DI.최초등록구분)='정기')																-- 최초등록 정기
And ((DI.등록구분)<>'외국인')																-- 외국인 제외
And ((#ex.회원번호) Is Null);																-- 제외조건 적용 (감사콜,결번,후원자반응1)

-- Welcome 02 --

SELECT 
	#wel01.회원번호, #wel01.인증여부 AS 내용, #wel01.가입경로, #wel01.소속, 
	iif(#wel01.납부방법='CMS',#wel01.CMS상태, iif(#wel01.납부방법='신용카드',#wel01.CARD상태,null)) AS 납부방법상태, 
	#wel01.회원상태, 
	CONVERT(DATE,#wel01.최초입력일) AS 최초입력일
FROM 
	#wel01
WHERE
	#wel01.채널별콜대상구분=1;																-- 위 쿼리의 콜대상자 적용
