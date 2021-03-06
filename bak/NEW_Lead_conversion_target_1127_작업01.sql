-- 작업 전 --

/*
	1. EN 원본데이터 추출 TRANSACTION - XLSX로 저장후 가져오기 
		대상:[dbo].[en_data]
	2. DB0_clnt_i 가져오기
		대상:[dbo].[db0_clnt_i]
	3. petition_all 가져오기
		대상:[dbo].[petition_all]
	4. 업데이트 있을시 campaign_list 가져오기
		대상:[dbo].[campaign_list]
	5. 업데이트 있을시 통화거부자 목록 가져오기
		대상:[dbo].[tm_blacklist]
	 매핑편집: 대상 테이블의 행 삭제
*/

-- 작업 001 -- EN에서 추출한 데이터에서 따옴표 제거 및 출처정보를 [data1]에 취합


SELECT 
	REPLACE(List_EN.[Supporter Email],'"','') AS supporter_email,
	REPLACE(List_EN.[Korean name],'"','') AS korean_name, 
	REPLACE(List_EN.[phone_number],'"','') AS phone_number, 
	REPLACE(List_EN.[Campaign ID],'"','') AS campaign_id,
	REPLACE(List_EN.[Campaign Date],'"','') AS campaign_date,
	REPLACE(List_EN.[utm_source],'"','') AS utm_source,
	CASE
		WHEN REPLACE(List_EN.[utm_source],'"','') <> '' THEN REPLACE(List_EN.[utm_source],'"','')
		WHEN REPLACE(List_EN.[Campaign Data 33],'"','') <> '' THEN REPLACE(List_EN.[Campaign Data 33],'"','')
		WHEN REPLACE(List_EN.[Campaign Data 34],'"','') <> '' THEN REPLACE(List_EN.[Campaign Data 34],'"','')
		WHEN REPLACE(List_EN.[utm_source],'"','') = '' THEN NULL 
		ELSE NULL
	END AS data1

INTO #001

FROM
	[local].[dbo].[en_data] AS List_EN


-- 작업 001-1 -- [data1]에 취합된 출처정보를 분류하여 [data2]에 정리 서명일이 이틀 이내인 자료 제외


SELECT *, 
	CASE
		WHEN #001.[data1] IS NULL THEN 'Unknown'
		WHEN #001.[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN #001.[data1] LIKE '%naver%' OR #001.[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN #001.[data1] LIKE '%kakao%' THEN '다음카카오'
		WHEN #001.[data1] LIKE '%act.greenpeace%' OR #001.[data1] LIKE '%me2.do%' THEN '그린피스서명페이지'
		WHEN #001.[data1] LIKE '%greenpeace.org%' OR #001.[data1] LIKE '%P3%' THEN '그린피스홈페이지'
		WHEN #001.[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN #001.[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN #001.[data1] LIKE '%slownews%' OR #001.[data1] LIKE '%huffing%' THEN CONCAT('언론사-', Left(#001.[data1],12))
		WHEN #001.[data1] LIKE '%twitter%' THEN 'Twitter'
		WHEN #001.[data1] LIKE '%honeyscreen%' THEN 'Honeyscreen'
		ELSE CONCAT('기타-', Left(#001.[data1],12))
	END AS data2

INTO #001_1

FROM #001

WHERE 
	(#001.[campaign_date] <= GETDATE() - 2)


-- 작업 002 -- 전화번호에서 기호 제거
DROP TABLE IF EXISTS #002

SELECT 
	#001_1.[supporter_email], 
	#001_1.[korean_name], 
	#001_1.[phone_number], 
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(#001_1.[phone_number],' ',''),'-',''),'*',''),'.',''),'*','') AS phone_number_1,
	#001_1.[campaign_id], 
	#001_1.[campaign_date], 
	SUBSTRING(#001_1.[data1],1,12) AS datapart, 
	#001_1.[data2] AS source
INTO #002
FROM #001_1

-- 작업 002-1 -- 전화번호 앞의 국가번호 82 제거

SELECT 
	#002.[supporter_email], 
	#002.[korean_name], 
	#002.[phone_number], 
	#002.[phone_number_1],
	CASE
		WHEN LEFT(#002.[phone_number_1],2)='82' THEN SUBSTRING(#002.[phone_number_1],3,20)
		ELSE #002.[phone_number_1]
	END AS phone_number_2,
	#002.[campaign_id], 
	#002.[campaign_date], 
	#002.[datapart], 
	#002.[source]
INTO #002_1
FROM #002

-- 작업 002-2 -- 휴대폰 형식에 맞는 번호에 'comp' 및 '-' 삽입
DROP TABLE IF EXISTS #002_2
SELECT 
	#002_1.[supporter_email], 
	#002_1.[korean_name], 
	#002_1.[phone_number], 
	#002_1.[phone_number_1],
	#002_1.[phone_number_2],
	CASE 
		WHEN SUBSTRING(phone_number_2,1,3) in ('010','011') AND LEN(phone_number_2)=11 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,4),'-',SUBSTRING(phone_number_2,8,4))
		WHEN SUBSTRING(phone_number_2,1,2) in ('10','11') AND LEN(phone_number_2)=10 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,4),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '011' AND LEN(phone_number_2)=10 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '11' AND LEN(phone_number_2)=9 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '016' AND LEN(phone_number_2)=10 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '16' AND LEN(phone_number_2)=9 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '017' AND LEN(phone_number_2)=10 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '17' AND LEN(phone_number_2)=9 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '019' AND LEN(phone_number_2)=10 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '19' AND LEN(phone_number_2)=9 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,1) in ('2','3','4','5','6','7','8','9') AND LEN(phone_number_2)=8 THEN CONCAT('comp','010','-',SUBSTRING(phone_number_2,1,4),'-',SUBSTRING(phone_number_2,5,4))
		ELSE phone_number_2
	END AS phone_number_3,
	#002_1.[campaign_id], 
	#002_1.[campaign_date], 
	#002_1.[datapart], 
	#002_1.[source]
INTO #002_2
FROM #002_1


-- 작업 003 -- 캠페인 코드에 맞게 캠페인 한국명 붙임

SELECT 
	#002_2.[supporter_email], 
	#002_2.[korean_name], 
	#002_2.[phone_number], 
	#002_2.[phone_number_3], 
	#002_2.[campaign_id], 
	[local].[dbo].[campaign_list].[campaign_name_kr],
	#002_2.[campaign_date], 
	#002_2.[datapart], 
	#002_2.[source]
INTO 
	#003
FROM
	#002_2 LEFT JOIN [local].[dbo].[campaign_list]
ON 
	#002_2.[campaign_id] = [local].[dbo].[campaign_list].[campaign_id]
	
-- petition_all_180 -- 기존의 [petition_all] 테이블에서 180일 이내 등록된 자료만 선택

DROP TABLE IF EXISTS [local].[dbo].[petition_all_180]
SELECT * 
INTO 
	[local].[dbo].[petition_all_180]
FROM 
	[local].[dbo].[petition_all]
WHERE
	[local].[dbo].[petition_all].[year_] >= GETDATE() - 180
	
--  작업 003-1 -- 180일 이내에 [petition_all]에 기록된 사람 제외 (휴대폰 및 이메일 기준)

SELECT
	#003.[supporter_email], 
	#003.[korean_name], 
	#003.[phone_number], 
	#003.[phone_number_3], 
	#003.[campaign_id], 
	#003.[campaign_name_kr],
	#003.[campaign_date], 
	#003.[datapart], 
	#003.[source]
INTO 
	#003_1
FROM 
	(#003 LEFT JOIN [local].[dbo].[petition_all_180]
	ON 
	[local].[dbo].[petition_all_180].[Phone] = #003.[phone_number]) LEFT JOIN [local].[dbo].[petition_all_180] AS petition_all_180_email
ON 
	#003.[supporter_email] = [petition_all_180_email].[Mail]
WHERE 
	#003.[phone_number] IS NOT NULL
	AND
	#003.[phone_number] <> ''
	AND
	[local].[dbo].[petition_all_180].[Phone] IS NULL
	AND
	[petition_all_180_email].[Mail] IS NULL

-- 작업 003-2 -블랙리스트 제외 (휴대폰 및 이메일 기준)

SELECT
	#003_1.[supporter_email], 
	#003_1.[korean_name], 
	#003_1.[phone_number], 
	#003_1.[phone_number_3], 
	#003_1.[campaign_id], 
	#003_1.[campaign_name_kr],
	#003_1.[campaign_date], 
	#003_1.[datapart], 
	#003_1.[source]
INTO 
	#003_2
FROM 
	(#003_1 LEFT JOIN [local].[dbo].[tm_blacklist]
	ON 
	[local].[dbo].[tm_blacklist].[phone_number] = REPLACE(#003_1.[phone_number_3],'comp','')) LEFT JOIN [local].[dbo].[tm_blacklist] AS tm_blacklist_email
ON 
	#003_1.[supporter_email] = [tm_blacklist_email].[email]
WHERE 
	#003_1.[phone_number] IS NOT NULL
	AND
	#003_1.[phone_number] <> ''
	AND
	[local].[dbo].[tm_blacklist].[phone_number] IS NULL
	AND
	[tm_blacklist_email].[email] IS NULL


-- db0_clnt_i_phone_no -- 기존 후원자 자료 로컬 테이블로 등록

DROP TABLE IF EXISTS [local].[dbo].[db0_clnt_i_phone_mail]
SELECT REPLACE([local].[dbo].[db0_clnt_i].[휴대전화번호],'-','') AS mrm_phone_number,
	[local].[dbo].[db0_clnt_i].[이메일] AS mrm_email
INTO [local].[dbo].[db0_clnt_i_phone_mail]
FROM [local].[dbo].[db0_clnt_i]
WHERE [local].[dbo].[db0_clnt_i].[휴대전화번호] IS NOT NULL

-- 작업 004 -- 기존 후원자 제외 (휴대폰 및 이메일 기준)

SELECT 
	#003_2.[supporter_email], 
	#003_2.[korean_name], 
	#003_2.[phone_number], 
	#003_2.[phone_number_3], 
	#003_2.[campaign_id], 
	#003_2.[campaign_name_kr],
	#003_2.[campaign_date], 
	#003_2.[datapart], 
	#003_2.[source]
INTO #004
FROM
	(#003_2 LEFT JOIN [local].[dbo].[db0_clnt_i_phone_mail]
	ON 
	REPLACE(REPLACE(#003_2.[phone_number_3],'comp',''),'-','') = [local].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number]) LEFT JOIN [local].[dbo].[db0_clnt_i_phone_mail] AS clnt_i_email
ON 
	#003_2.[supporter_email] = [clnt_i_email].[mrm_email]
WHERE 
	#003_2.[phone_number] <> ''
	AND
	[local].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number] IS NULL
	AND
	[clnt_i_email].[mrm_email] IS NULL

-- 작업 005 -- 

SELECT 
	#004.[supporter_email], 
	#004.[korean_name], 
	#004.[phone_number], 
	REPLACE(#004.[phone_number_3],'comp','') AS modified_number, 
	CASE
		WHEN SUBSTRING(#004.[phone_number_3],1,4) = 'comp' THEN 'T'
		ELSE 'F'
	END AS modified_tf,
	#004.[campaign_id], 
	#004.[campaign_name_kr],
	#004.[campaign_date], 
	#004.[datapart], 
	#004.[source]
INTO
	#005
FROM
	#004


-- 작업 005 -- 전화번호 형식에 맞지 않는 번호 수정할 수 있도록 정렬하여 테이블 생성
DROP TABLE IF EXISTS [local].[dbo].[petition_daily]
SELECT TOP 10000
	#005.[supporter_email], 
	#005.[korean_name], 
	#005.[phone_number], 
	#005.[modified_tf],
	#005.[campaign_id], 
	#005.[campaign_name_kr],
	#005.[campaign_date], 
	#005.[datapart], 
	#005.[source]
INTO
	[local].[dbo].[petition_daily]
FROM
	#005
ORDER BY
	modified_tf ASC


-- [local].[dbo].[petition_daily]에서 양식에 맞지 않는 번호 삭제 및 수정 --

-- 중복 제거 필요 --