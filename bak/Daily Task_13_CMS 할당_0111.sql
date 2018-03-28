

--실행시 선택되는 첫번째 결과는 LC가입자들 중 결제문제가 있는 가입자들이다.
--해당 가입자들은 가입경로 및 소속을 확인하여 TM에이전시에 결제정보 수정을 요청한다.
--이미 수정이 된 경우는 CMS증빙콜을 할당하여 새로운 결제정보가 입력될 수 있도록 한다.

-- 실행시 선택되는 두번째 결과는 CMS증빙자료 등록이 필요한 건들


-- 제외조건 --
DROP TABLE IF EXISTS #ex
SELECT 
	H.회원번호
INTO 
	#ex
FROM
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AS H		-- History
WHERE 
	(H.[기록분류] = 'TM_감사')					-- 감사콜 기록 있는 후원자
	OR
	(H.[기록분류상세] = '결번')					-- 결번
	OR
	(H.[기록구분2] LIKE '%1%')					-- 후원자반응 '1.통화거부/강한불만'
	OR
	(H.기록분류 LIKE '%CMS%' AND H.처리진행사항 LIKE '%진행%')  -- CMS콜 진행중


-- LC가입자 중 CMS 및 신용카드 문제 01 --
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
		ELSE NULL
	END AS 인증여부,																-- 인증실패여부/녹취대상여부 입력
	CASE
		WHEN D.가입경로 IN ('Lead Conversion','전화')
			AND [D].[납부방법]='CMS'
			AND [D].[CMS상태] IN ('신규실패','수정실패','') THEN '1'						-- 전화/LC: CMS실패한 경우
		WHEN D.가입경로 IN ('Lead Conversion','전화')
			AND [D].[납부방법]='신용카드'
			AND [D].[CARD상태] IN ('승인대기','') THEN '1'									-- 전화/LC: 신용카드
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
	D.회원상태 Not In ('Canceled','Other')													-- 회원상태 Cancel 및 Other 제외
And ((IIf(D.집전화번호 Is Not Null,1,0)+IIf(D.직장전화번호 Is Not Null,1,0)+IIf(D.휴대전화번호='유',1,0))>0) -- 전화번호가 있는 경우만 선택
And ((D.가입일)>='2017-01-01')																-- 2017년 이후 가입자 (수정 필요한지 확인)
And ((D.최초등록구분)='정기')																-- 최초등록 정기
And ((D.등록구분)!='외국인')																-- 외국인 제외
And ((#ex.회원번호) Is Null)																-- 제외조건 적용 (감사콜,결번,후원자반응1)


-- LC가입자 중 CMS 및 신용카드 문제 02 --

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

SELECT * 
FROM #wel02

-- CMS_01 -- Normal 정기 회원중에 CMS대기 중이고 증빙 등록 필요한 경우
DROP TABLE IF EXISTS #cms_01
SELECT 
	D.회원번호, D.납부방법, D.CMS상태, D.가입경로, D.가입일, D.최초입력일
INTO #cms_01
FROM 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_후원자정보] AS D		-- Donors Information
WHERE 
	(D.납부방법 = 'CMS')								-- CMS
	AND (D.CMS상태 LIKE '%대기%')						-- '신규대기/수정대기'
	AND (D.회원상태 = 'Normal')							-- 회원상태 'Normal'
	AND (D.최초등록구분 = '정기')						-- 최초등록 '정기'
	AND (D.CMS증빙자료등록필요='Y')						-- CMS증빙 등록필요


-- CMS_02 -- 
DROP TABLE IF EXISTS #cms_02
SELECT 
	H.회원번호, H.기록일시, H.기록분류, H.기록분류상세, H.참고일, H.처리진행사항, H.제목, H.최초입력자, H.기록구분2, 
	CASE 
		WHEN H.[처리진행사항] LIKE '%지연%' THEN '1'
		WHEN H.[처리진행사항] LIKE '%진행%' THEN '1'
		ELSE '0'
	END AS 진행중TF,
	CASE
		WHEN H.[참고일] >= GETDATE() - 6 THEN '1'
		ELSE '0'
	END AS 최근TF
INTO #cms_02
FROM 
	#cms_01 
INNER JOIN 
	[MRMRT].[그린피스동아시아서울사무소0868].[dbo].[UV_GP_관리기록] AS H 
ON #cms_01.회원번호 = H.회원번호

WHERE 
	(H.기록분류 NOT IN ('Freezing','Impact report','Other mailings','Regular E-mail','Regular SMS','survey response','Welcome pack')) -- 'Annual report' 추가할지 확인
	AND (([H].[처리진행사항] Like '%지연%') OR ([H].[처리진행사항] Like '%진행%'))		-- 위의 기록분류가 아니면서 진행중인 기록만 선택
	OR 
	((H.기록분류) NOT IN ('Freezing','Impact report','Other mailings','Regular E-mail','Regular SMS','survey response','Welcome pack')) 
	AND ([H].[참고일]>=GETDATE()-6)														-- 위의 기록분류가 아니면서 참고일이 5일 이내인 기록만 선택 


-- CMSpf_03 --

SELECT 
	#cms_01.회원번호, '녹취대상' AS 내용, #cms_01.가입경로, #cms_01.납부방법, #cms_01.CMS상태, #cms_01.가입일, 
	CONVERT(DATE,#cms_01.최초입력일) AS 최초입력일
FROM 
	#cms_01 LEFT JOIN #cms_02
ON 
	#cms_01.회원번호 = #cms_02.회원번호
WHERE 
	CONVERT(DATE,#cms_01.최초입력일) <= GETDATE()-3
	AND 
	#cms_02.회원번호 IS NULL

