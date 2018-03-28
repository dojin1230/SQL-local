
-- �۾� 001 -- EN ���������� ���� TRANSACTION - XLSX

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
	[work].[dbo].[Sheet0$] AS List_EN


-- �۾� 001-1 --

DROP TABLE IF EXISTS [work].[dbo].[001-1]

SELECT *, 
	CASE
		WHEN [work].[dbo].[001].[data1] IS NULL THEN 'Unknown'
		WHEN [work].[dbo].[001].[data1] LIKE '%facebook%' THEN 'Facebook'
		WHEN [work].[dbo].[001].[data1] LIKE '%naver%' OR [work].[dbo].[001].[data1] LIKE '%happybean%' THEN 'NAVER'
		WHEN [work].[dbo].[001].[data1] LIKE '%kakao%' THEN '����īī��'
		WHEN [work].[dbo].[001].[data1] LIKE '%act.greenpeace%' OR [work].[dbo].[001].[data1] LIKE '%me2.do%' THEN '�׸��ǽ�����������'
		WHEN [work].[dbo].[001].[data1] LIKE '%greenpeace.org%' OR [work].[dbo].[001].[data1] LIKE '%P3%' THEN '�׸��ǽ�Ȩ������'
		WHEN [work].[dbo].[001].[data1] LIKE '%instagram%' THEN 'Instagram'
		WHEN [work].[dbo].[001].[data1] LIKE '%youtube%' THEN 'Youtube'
		WHEN [work].[dbo].[001].[data1] LIKE '%slownews%' OR [work].[dbo].[001].[data1] LIKE '%huffing%' THEN CONCAT('��л�-', Left([work].[dbo].[001].[data1],10))
		WHEN [work].[dbo].[001].[data1] LIKE '%twitter%' THEN 'Twitter'
		WHEN [work].[dbo].[001].[data1] LIKE '%honeyscreen%' THEN 'Honeyscreen'
		ELSE CONCAT('��Ÿ-', Left([work].[dbo].[001].[data1],10))
	END AS data2

INTO [work].[dbo].[001-1]

FROM [work].[dbo].[001]

WHERE 
	([work].[dbo].[001].[campaign_date] <= GETDATE() - 2)


-- �۾� 002 --
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

-- �۾� 002-1 --
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

-- �۾� 002-2 --
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

--  �۾� 003 --
/*
SELECT 

	Petition_campaign.[Campaign name_KR], [002].[Supporter Email], [002].[Korean name], [002].phone_number, 
	[002].phone_number3, [002].[Campaign ID], [002].[Campaign Date], [002].datapart, [002].Source

FROM 

	Petition_all AS Petition_all_1 

	RIGHT JOIN 
		(Petition_all 
			RIGHT JOIN 
				(002 LEFT JOIN Petition_campaign 
					ON [002].[Campaign ID] = Petition_campaign.[Campaign ID]
				) --[Campaign ID] �������� ķ���θ��� [002]�� ����
			ON Petition_all.Phone = [002].phone_number
		) --����ȣ �������� [1�� ���ε� 002]�� [Petition_all]�� ����
	ON Petition_all_1.Mail = [002].[Supporter Email] --�̸��� �������� [2�� ���ε� 002]�� [Petition_all]�� ����

WHERE (
		(([002].phone_number) Is Not Null) 
		AND 
		((Petition_all.Phone) Is Null) 
		AND 
		((Petition_all_1.Mail) Is Null)
	) --���ε� ���̺��� ������ [Petition_all] ���̺� ����ȣ�� �����ּҰ� ���� ��� ���� (������ Petition_all�� �ִ� ��� �ɷ���)

ORDER BY Petition_campaign.[Campaign name_KR];
*/


		