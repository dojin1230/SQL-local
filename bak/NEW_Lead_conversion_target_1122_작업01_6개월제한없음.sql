-- �۾� �� --

/*
	1. EN ���������� ���� TRANSACTION - XLSX�� ������ �������� 
		���:[dbo].[en_data]
	2. DB0_clnt_i ��������
		���:[dbo].[db0_clnt_i]
	3. petition_all ��������
		���:[dbo].[petition_all]
	3. ������Ʈ ������ campaign_list ��������
	 ��������: ��� ���̺��� �� ����
*/

-- �۾� 001 -- 

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


-- �۾� 001-1 --


SELECT *, 
	CASE
		WHEN #001.[data1] IS NULL THEN 'Unknown'
		WHEN #001.[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN #001.[data1] LIKE '%naver%' OR #001.[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN #001.[data1] LIKE '%kakao%' THEN '����īī��'
		WHEN #001.[data1] LIKE '%act.greenpeace%' OR #001.[data1] LIKE '%me2.do%' THEN '�׸��ǽ�����������'
		WHEN #001.[data1] LIKE '%greenpeace.org%' OR #001.[data1] LIKE '%P3%' THEN '�׸��ǽ�Ȩ������'
		WHEN #001.[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN #001.[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN #001.[data1] LIKE '%slownews%' OR #001.[data1] LIKE '%huffing%' THEN CONCAT('��л�-', Left(#001.[data1],10))
		WHEN #001.[data1] LIKE '%twitter%' THEN 'Twitter'
		WHEN #001.[data1] LIKE '%honeyscreen%' THEN 'Honeyscreen'
		ELSE CONCAT('��Ÿ-', Left(#001.[data1],10))
	END AS data2

INTO #001_1

FROM #001

WHERE 
	(#001.[campaign_date] <= GETDATE() - 2)


-- �۾� 002 --

SELECT 
	#001_1.[supporter_email], 
	#001_1.[korean_name], 
	#001_1.[phone_number], 
	REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(#001_1.[phone_number],' ',''),'-',''),'*',''),'.',''),'*','') AS phone_number_1,
	#001_1.[campaign_id], 
	#001_1.[campaign_date], 
	SUBSTRING(#001_1.[data1],1,10) AS datapart, 
	#001_1.[data2] AS source
INTO #002
FROM #001_1

-- �۾� 002-1 --

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

-- �۾� 002-2 --

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


--  �۾� 003 -- 

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
	
--  �۾� 003-1 --

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
	(#003 LEFT JOIN [local].[dbo].[petition_all]
	ON 
	[local].[dbo].[petition_all].[Phone] = #003.[phone_number]) LEFT JOIN [local].[dbo].[petition_all] AS petition_all_email
ON 
	#003.[supporter_email] = [petition_all_email].[Mail]
WHERE 
	#003.[phone_number] IS NOT NULL
	AND
	#003.[phone_number] <> ''
	AND
	[local].[dbo].[petition_all].[Phone] IS NULL
	AND
	[petition_all_email].[Mail] IS NULL

-- �۾� 003-2 -- ������Ʈ ���� �۾� �߰�

-- db0_clnt_i_phone_no --

DROP TABLE IF EXISTS [local].[dbo].[db0_clnt_i_phone_mail]
SELECT REPLACE([local].[dbo].[db0_clnt_i].[�޴���ȭ��ȣ],'-','') AS mrm_phone_number,
	[local].[dbo].[db0_clnt_i].[�̸���] AS mrm_email
INTO [local].[dbo].[db0_clnt_i_phone_mail]
FROM [local].[dbo].[db0_clnt_i]
WHERE [local].[dbo].[db0_clnt_i].[�޴���ȭ��ȣ] IS NOT NULL

-- �۾� 004 --
DROP TABLE IF EXISTS [local].[dbo].[004]
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
	[local].[dbo].[004]
FROM
	(#003_1 LEFT JOIN [local].[dbo].[db0_clnt_i_phone_mail]
	ON 
	REPLACE(REPLACE(#003_1.[phone_number_3],'comp',''),'-','') = [local].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number]) LEFT JOIN [local].[dbo].[db0_clnt_i_phone_mail] AS clnt_i_email
ON 
	#003_1.[supporter_email] = [clnt_i_email].[mrm_email]
WHERE 
	#003_1.[phone_number] <> ''
	AND
	[local].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number] IS NULL
	AND
	[clnt_i_email].[mrm_email] IS NULL

-- �۾� 005 --
DROP TABLE IF EXISTS [local].[dbo].[petition_daily]
SELECT TOP 10000
	[local].[dbo].[004].[supporter_email], 
	[local].[dbo].[004].[korean_name], 
	[local].[dbo].[004].[phone_number], 
	REPLACE([local].[dbo].[004].[phone_number_3],'comp','') AS modified_number, 
	CASE
		WHEN SUBSTRING([local].[dbo].[004].[phone_number_3],1,4) = 'comp' THEN 'T'
		ELSE 'F'
	END AS modified_tf,
	[local].[dbo].[004].[campaign_id], 
	[local].[dbo].[004].[campaign_name_kr],
	[local].[dbo].[004].[campaign_date], 
	[local].[dbo].[004].[datapart], 
	[local].[dbo].[004].[source]
INTO
	[local].[dbo].[petition_daily]
FROM
	[local].[dbo].[004]
ORDER BY
	modified_tf ASC



-- [local].[dbo].[petition_daily]���� ��Ŀ� ���� �ʴ� ��ȣ ���� �� ���� --

-- �ߺ� ���� �ʿ� --