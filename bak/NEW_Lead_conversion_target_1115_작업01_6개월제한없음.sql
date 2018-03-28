-- 작업 전 --

/*
	1. EN 원본데이터 추출 TRANSACTION - XLSX로 저장후 가져오기 
		대상:[dbo].[en_data]
	2. DB0_clnt_i 가져오기
		대상:[dbo].[db0_clnt_i]
	3. petition_all 가져오기
		대상:[dbo].[petition_all]
	3. 업데이트 있을시 campaign_list 가져오기
	 매핑편집: 대상 테이블의 행 삭제
*/

-- 작업 001 -- 

DROP TABLE IF EXISTS [work].[dbo].[001]

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

INTO [work].[dbo].[001]

FROM
	[work].[dbo].[en_data] AS List_EN


-- 작업 001-1 --

DROP TABLE IF EXISTS [work].[dbo].[001-1]

SELECT *, 
	CASE
		WHEN [work].[dbo].[001].[data1] IS NULL THEN 'Unknown'
		WHEN [work].[dbo].[001].[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN [work].[dbo].[001].[data1] LIKE '%naver%' OR [work].[dbo].[001].[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN [work].[dbo].[001].[data1] LIKE '%kakao%' THEN '다음카카오'
		WHEN [work].[dbo].[001].[data1] LIKE '%act.greenpeace%' OR [work].[dbo].[001].[data1] LIKE '%me2.do%' THEN '그린피스서명페이지'
		WHEN [work].[dbo].[001].[data1] LIKE '%greenpeace.org%' OR [work].[dbo].[001].[data1] LIKE '%P3%' THEN '그린피스홈페이지'
		WHEN [work].[dbo].[001].[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN [work].[dbo].[001].[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN [work].[dbo].[001].[data1] LIKE '%slownews%' OR [work].[dbo].[001].[data1] LIKE '%huffing%' THEN CONCAT('언론사-', Left([work].[dbo].[001].[data1],10))
		WHEN [work].[dbo].[001].[data1] LIKE '%twitter%' THEN 'Twitter'
		WHEN [work].[dbo].[001].[data1] LIKE '%honeyscreen%' THEN 'Honeyscreen'
		ELSE CONCAT('기타-', Left([work].[dbo].[001].[data1],10))
	END AS data2

INTO [work].[dbo].[001-1]

FROM [work].[dbo].[001]

WHERE 
	([work].[dbo].[001].[campaign_date] <= GETDATE() - 2)


-- 작업 002 --
DROP TABLE IF EXISTS [work].[dbo].[002]

SELECT 
	[work].[dbo].[001-1].[supporter_email], 
	[work].[dbo].[001-1].[korean_name], 
	[work].[dbo].[001-1].[phone_number], 
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([work].[dbo].[001-1].[phone_number],' ',''),'-',''),'*',''),'.',''),'*','') AS phone_number_1,
	[work].[dbo].[001-1].[campaign_id], 
	[work].[dbo].[001-1].[campaign_date], 
	SUBSTRING([work].[dbo].[001-1].[data1],1,10) AS datapart, 
	[work].[dbo].[001-1].[data2] AS source
INTO [work].[dbo].[002]
FROM [work].[dbo].[001-1]

-- 작업 002-1 --
DROP TABLE IF EXISTS [work].[dbo].[002-1]
SELECT 
	[work].[dbo].[002].[supporter_email], 
	[work].[dbo].[002].[korean_name], 
	[work].[dbo].[002].[phone_number], 
	[work].[dbo].[002].[phone_number_1],
	CASE
		WHEN LEFT([work].[dbo].[002].[phone_number_1],2)='82' THEN SUBSTRING([work].[dbo].[002].[phone_number_1],3,20)
		ELSE [work].[dbo].[002].[phone_number_1]
	END AS phone_number_2,
	[work].[dbo].[002].[campaign_id], 
	[work].[dbo].[002].[campaign_date], 
	[work].[dbo].[002].[datapart], 
	[work].[dbo].[002].[source]
INTO [work].[dbo].[002-1]
FROM [work].[dbo].[002]

-- 작업 002-2 --
DROP TABLE IF EXISTS [work].[dbo].[002-2]
SELECT 
	[work].[dbo].[002-1].[supporter_email], 
	[work].[dbo].[002-1].[korean_name], 
	[work].[dbo].[002-1].[phone_number], 
	[work].[dbo].[002-1].[phone_number_1],
	[work].[dbo].[002-1].[phone_number_2],
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
	[work].[dbo].[002-1].[campaign_id], 
	[work].[dbo].[002-1].[campaign_date], 
	[work].[dbo].[002-1].[datapart], 
	[work].[dbo].[002-1].[source]
INTO [work].[dbo].[002-2]
FROM [work].[dbo].[002-1]


--  작업 003 -- 
DROP TABLE IF EXISTS [work].[dbo].[003]
SELECT 
	[work].[dbo].[002-2].[supporter_email], 
	[work].[dbo].[002-2].[korean_name], 
	[work].[dbo].[002-2].[phone_number], 
	[work].[dbo].[002-2].[phone_number_3], 
	[work].[dbo].[002-2].[campaign_id], 
	[work].[dbo].[campaign_list].[campaign_name_kr],
	[work].[dbo].[002-2].[campaign_date], 
	[work].[dbo].[002-2].[datapart], 
	[work].[dbo].[002-2].[source]
INTO 
	[work].[dbo].[003]
FROM
	[work].[dbo].[002-2] LEFT JOIN [work].[dbo].[campaign_list]
ON 
	[work].[dbo].[002-2].[campaign_id] = [work].[dbo].[campaign_list].[campaign_id]
	
--  작업 003-1 --

DROP TABLE IF EXISTS [work].[dbo].[003-1]
SELECT
	[work].[dbo].[003].[supporter_email], 
	[work].[dbo].[003].[korean_name], 
	[work].[dbo].[003].[phone_number], 
	[work].[dbo].[003].[phone_number_3], 
	[work].[dbo].[003].[campaign_id], 
	[work].[dbo].[003].[campaign_name_kr],
	[work].[dbo].[003].[campaign_date], 
	[work].[dbo].[003].[datapart], 
	[work].[dbo].[003].[source]
INTO 
	[work].[dbo].[003-1]
FROM 
	([work].[dbo].[003] LEFT JOIN [work].[dbo].[petition_all]
	ON 
	[work].[dbo].[petition_all].[Phone] = [work].[dbo].[003].[phone_number]) LEFT JOIN [work].[dbo].[petition_all] AS petition_all_email
ON 
	[work].[dbo].[003].[supporter_email] = [petition_all_email].[Mail]
WHERE 
	[work].[dbo].[003].[phone_number] IS NOT NULL
	AND
	[work].[dbo].[003].[phone_number] <> ''
	AND
	[work].[dbo].[petition_all].[Phone] IS NULL
	AND
	[petition_all_email].[Mail] IS NULL

-- 작업 003-2 -- 블랙리스트 제거 작업 추가

-- db0_clnt_i_phone_no --

DROP TABLE IF EXISTS [work].[dbo].[db0_clnt_i_phone_mail]
SELECT REPLACE([work].[dbo].[db0_clnt_i].[휴대전화번호],'-','') AS mrm_phone_number,
	[work].[dbo].[db0_clnt_i].[이메일] AS mrm_email
INTO [work].[dbo].[db0_clnt_i_phone_mail]
FROM [work].[dbo].[db0_clnt_i]
WHERE [work].[dbo].[db0_clnt_i].[휴대전화번호] IS NOT NULL

-- 작업 004 --
DROP TABLE IF EXISTS [work].[dbo].[004]
SELECT 
	[work].[dbo].[003-1].[supporter_email], 
	[work].[dbo].[003-1].[korean_name], 
	[work].[dbo].[003-1].[phone_number], 
	[work].[dbo].[003-1].[phone_number_3], 
	[work].[dbo].[003-1].[campaign_id], 
	[work].[dbo].[003-1].[campaign_name_kr],
	[work].[dbo].[003-1].[campaign_date], 
	[work].[dbo].[003-1].[datapart], 
	[work].[dbo].[003-1].[source]
INTO [work].[dbo].[004]
FROM
	([work].[dbo].[003-1] LEFT JOIN [work].[dbo].[db0_clnt_i_phone_mail]
	ON 
	REPLACE(REPLACE([work].[dbo].[003-1].[phone_number_3],'comp',''),'-','') = [work].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number]) LEFT JOIN [work].[dbo].[db0_clnt_i_phone_mail] AS clnt_i_email
ON 
	[work].[dbo].[003-1].[supporter_email] = [clnt_i_email].[mrm_email]
WHERE 
	[work].[dbo].[003-1].[phone_number] <> ''
	AND
	[work].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number] IS NULL
	AND
	[clnt_i_email].[mrm_email] IS NULL

-- 작업 005 --
DROP TABLE IF EXISTS [work].[dbo].[petition_daily]
SELECT TOP 10000
	[work].[dbo].[004].[supporter_email], 
	[work].[dbo].[004].[korean_name], 
	[work].[dbo].[004].[phone_number], 
	REPLACE([work].[dbo].[004].[phone_number_3],'comp','') AS modified_number, 
	CASE
		WHEN SUBSTRING([work].[dbo].[004].[phone_number_3],1,4) = 'comp' THEN 'T'
		ELSE 'F'
	END AS modified_tf,
	[work].[dbo].[004].[campaign_id], 
	[work].[dbo].[004].[campaign_name_kr],
	[work].[dbo].[004].[campaign_date], 
	[work].[dbo].[004].[datapart], 
	[work].[dbo].[004].[source]
INTO
	[work].[dbo].[petition_daily]
FROM
	[work].[dbo].[004]
ORDER BY
	modified_tf ASC

-- [work].[dbo].[petition_daily]에서 양식에 맞지 않는 번호 삭제 및 수정 --

-- 중복 제거 필요 --