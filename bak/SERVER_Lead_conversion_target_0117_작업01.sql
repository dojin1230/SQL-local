-- �۾� �� --

/*
	1. EN ���������� ���� TRANSACTION - csv�� ������ [Import flat file]�� �������� (���� ���̺� ����) 
		���:[dbo].[en_data]
	2. DB0_clnt_i ��������
		���:[dbo].[db0_clnt_i]
	3. petition_all ��������
		���:[dbo].[petition_all]
	4. ������Ʈ ������ campaign_list ��������
		���:[dbo].[campaign_list]
	5. ������Ʈ ������ ��ȭ�ź��� ��� ��������
		���:[dbo].[lead_donotcall]
	 ��������: ��� ���̺��� �� ����
*/

-- �Ｚ ���� �ߺ� �ڷ� ���� -- 

DELETE FROM [work].[dbo].[en_data]
WHERE [work].[dbo].[en_data].[Campaign_Data_2] = 'Kim'							-- �Ｚ ķ���� CEO���� �̸��� ������ ��� ������ ���尡 �ߺ����� �Էµ�

-- �׸��ǽ� ���� (�׽�Ʈ) �ڷ� ���� --

DELETE FROM [work].[dbo].[en_data]
WHERE [work].[dbo].[en_data].[Supporter_Email] LIKE '%greenpeace%'
	OR [work].[dbo].[en_data].[Korean_name] LIKE '%test%'
	OR [work].[dbo].[en_data].[Korean_name] LIKE '%�׽�Ʈ%'


-- �۾� 001 -- EN���� ������ ������ ��ó������ [data1]�� ���� -- 



DROP TABLE IF EXISTS #001
SELECT 
	List_EN.[Supporter_Email] AS supporter_email,
	List_EN.[Korean_name] AS korean_name, 
	List_EN.[phone_number] AS phone_number, 
	List_EN.[Campaign_ID] AS campaign_id,
	List_EN.[Campaign_Date] AS campaign_date,
	List_EN.[utm_source] AS utm_source,
	CASE
		WHEN List_EN.[utm_source] <> '' THEN List_EN.[utm_source]
		WHEN List_EN.[Campaign_Data_33] <> '' THEN List_EN.[Campaign_Data_33]
		WHEN List_EN.[Campaign_Data_34] <> '' THEN List_EN.[Campaign_Data_34]
		WHEN List_EN.[utm_source] = '' THEN NULL 
		ELSE NULL
	END AS data1

INTO #001

FROM
	[work].[dbo].[en_data] AS List_EN



-- �۾� 001-1 -- [data1]�� ���յ� ��ó������ �з��Ͽ� [data2]�� ���� �������� ��Ʋ �̳��� �ڷ� ����

DROP TABLE IF EXISTS #001_1
SELECT *, 
	CASE
		WHEN #001.[data1] IS NULL THEN 'Unknown'
		WHEN #001.[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN #001.[data1] LIKE '%naver%' OR #001.[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN #001.[data1] LIKE '%kakao%' THEN N'����īī��'
		WHEN #001.[data1] LIKE '%act.greenpeace%' OR #001.[data1] LIKE '%me2.do%' THEN N'�׸��ǽ�����������'
		WHEN #001.[data1] LIKE '%greenpeace.org%' OR #001.[data1] LIKE '%P3%' THEN N'�׸��ǽ�Ȩ������'
		WHEN #001.[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN #001.[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN #001.[data1] LIKE '%slownews%' OR #001.[data1] LIKE '%huffing%' THEN CONCAT(N'��л�-', Left(#001.[data1],12))
		WHEN #001.[data1] LIKE '%twitter%' THEN 'Twitter'
		WHEN #001.[data1] LIKE '%honeyscreen%' THEN 'Honeyscreen'
		ELSE CONCAT(N'��Ÿ-', Left(#001.[data1],12))
	END AS data2

INTO #001_1

FROM #001

WHERE 
	(#001.[campaign_date] <= GETDATE() - 2)





-- �۾� 002 -- ��ȭ��ȣ���� ��ȣ ����
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


-- �۾� 002-1 -- ��ȭ��ȣ ���� ������ȣ 82 ����
DROP TABLE IF EXISTS #002_1
SELECT 
	#002.[supporter_email], 
	#002.[korean_name], 
	#002.[phone_number], 
	#002.[phone_number_1],
	CASE
		WHEN LEFT(#002.[phone_number_1],2)='82' THEN SUBSTRING(#002.[phone_number_1],3,20)
		WHEN LEFT(#002.[phone_number_1],3)='+82' THEN SUBSTRING(#002.[phone_number_1],4,20)
		ELSE #002.[phone_number_1]
	END AS phone_number_2,
	#002.[campaign_id], 
	#002.[campaign_date], 
	#002.[datapart], 
	#002.[source]
INTO #002_1
FROM #002



-- �۾� 002-2 -- �޴��� ���Ŀ� �´� ��ȣ�� 'comp' �� '-' ����
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
		WHEN SUBSTRING(phone_number_2,1,3) = '018' AND LEN(phone_number_2)=10 THEN CONCAT('comp',SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '18' AND LEN(phone_number_2)=9 THEN CONCAT('comp','0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
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


-- �۾� 003 -- ķ���� �ڵ忡 �°� ķ���� �ѱ��� ����
DROP TABLE IF EXISTS #003
SELECT 
	#002_2.[supporter_email], 
	#002_2.[korean_name], 
	#002_2.[phone_number], 
	#002_2.[phone_number_3], 
	#002_2.[campaign_id], 
	[work].[dbo].[campaign_list].[campaign_name_kr],
	#002_2.[campaign_date], 
	#002_2.[datapart], 
	#002_2.[source]
INTO 
	#003
FROM
	#002_2 LEFT JOIN [work].[dbo].[campaign_list]
ON 
	#002_2.[campaign_id] = [work].[dbo].[campaign_list].[campaign_id]
	
-- petition_all_90 -- ������ [petition_all] ���̺��� 90�� �̳� ��ϵ� �ڷḸ ����

DROP TABLE IF EXISTS [work].[dbo].[petition_all_90]
SELECT * 
INTO 
	[work].[dbo].[petition_all_90]
FROM 
	[work].[dbo].[petition_all]
WHERE
	[work].[dbo].[petition_all].[year_] >= GETDATE() - 90


--  �۾� 003-1 -- 90�� �̳��� [petition_all]�� ��ϵ� ��� ���� (�޴�����ȣ/������ �޴�����ȣ/�̸��� ����)
DROP TABLE IF EXISTS #003_1
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
	((#003 LEFT JOIN [work].[dbo].[petition_all_90]
		ON 
		[work].[dbo].[petition_all_90].[Phone] = #003.[phone_number]) LEFT JOIN [work].[dbo].[petition_all_90] AS petition_all_90_email
	ON 
	#003.[supporter_email] = [petition_all_90_email].[Mail]) LEFT JOIN [work].[dbo].[petition_all_90] AS petition_all_90_modified_phone
ON REPLACE(#003.[phone_number_3],'comp','') = [petition_all_90_modified_phone].[modified_phone]
WHERE 
	#003.[phone_number] IS NOT NULL
	AND
	#003.[phone_number] <> ''
	AND
	[work].[dbo].[petition_all_90].[Phone] IS NULL
	AND
	[petition_all_90_email].[Mail] IS NULL
	AND
	[petition_all_90_modified_phone].[modified_phone] IS NULL

-- �۾� 003-2 -- ������Ʈ(���ļ��Űź�,���,�׸��ǽ�����) ���� (�޴��� �� �̸��� ����)
DROP TABLE IF EXISTS #003_2
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
	(#003_1 LEFT JOIN [work].[dbo].[lead_donotcall]
	ON 
	[work].[dbo].[lead_donotcall].[phone_number] = REPLACE(#003_1.[phone_number_3],'comp','')) LEFT JOIN [work].[dbo].[lead_donotcall] AS lead_donotcall_email
ON 
	#003_1.[supporter_email] = [lead_donotcall_email].[email]
WHERE 
	#003_1.[phone_number] IS NOT NULL
	AND
	#003_1.[phone_number] <> ''
	AND
	[work].[dbo].[lead_donotcall].[phone_number] IS NULL
	AND
	[lead_donotcall_email].[email] IS NULL


-- db0_clnt_i_phone_no -- ���� �Ŀ��� �ڷ� ���� ���̺�� ���

DROP TABLE IF EXISTS [work].[dbo].[db0_clnt_i_phone_mail]
SELECT REPLACE([work].[dbo].[db0_clnt_i].[�޴���ȭ��ȣ],'-','') AS mrm_phone_number,
	[work].[dbo].[db0_clnt_i].[�̸���] AS mrm_email
INTO [work].[dbo].[db0_clnt_i_phone_mail]
FROM [work].[dbo].[db0_clnt_i]
WHERE [work].[dbo].[db0_clnt_i].[�޴���ȭ��ȣ] IS NOT NULL

-- �۾� 004 -- ���� �Ŀ��� ���� (�޴��� �� �̸��� ����)
DROP TABLE IF EXISTS #004
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
	(#003_2 LEFT JOIN [work].[dbo].[db0_clnt_i_phone_mail]
	ON 
	REPLACE(REPLACE(#003_2.[phone_number_3],'comp',''),'-','') = [work].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number]) LEFT JOIN [work].[dbo].[db0_clnt_i_phone_mail] AS clnt_i_email
ON 
	#003_2.[supporter_email] = [clnt_i_email].[mrm_email]
WHERE 
	#003_2.[phone_number] <> ''
	AND
	[work].[dbo].[db0_clnt_i_phone_mail].[mrm_phone_number] IS NULL
	AND
	[clnt_i_email].[mrm_email] IS NULL

-- �۾� 005 -- 
DROP TABLE IF EXISTS [work].[dbo].[petition_daily_before]
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
	[work].[dbo].[petition_daily_before]
FROM
	#004


-- �۾� 005 -- ��ȭ��ȣ ���Ŀ� ���� �ʴ� ��ȣ ������ �� �ֵ��� �����Ͽ� ���̺� ����
DROP TABLE IF EXISTS [work].[dbo].[petition_daily]
SELECT TOP 10000
	[work].[dbo].[petition_daily_before].[supporter_email], 
	[work].[dbo].[petition_daily_before].[korean_name], 
	[work].[dbo].[petition_daily_before].[phone_number], 
	[work].[dbo].[petition_daily_before].[modified_number],
	[work].[dbo].[petition_daily_before].[modified_tf],
	[work].[dbo].[petition_daily_before].[campaign_id], 
	[work].[dbo].[petition_daily_before].[campaign_name_kr],
	[work].[dbo].[petition_daily_before].[campaign_date], 
	[work].[dbo].[petition_daily_before].[datapart], 
	[work].[dbo].[petition_daily_before].[source]
INTO
	[work].[dbo].[petition_daily]
FROM
	[work].[dbo].[petition_daily_before]
ORDER BY
	modified_tf ASC


-- [work].[dbo].[petition_daily]���� ��Ŀ� ���� �ʴ� ��ȣ ���� �� ���� --

-- �ߺ� ���� �ʿ� --
