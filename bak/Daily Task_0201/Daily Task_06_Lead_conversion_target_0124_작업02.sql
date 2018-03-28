-- [work].[dbo].[petition_daily]�� ���� ��Ŀ� ���� �ʴ� ��ȣ ���� �� ���� �� --

  DELETE
  FROM [work].[dbo].[petition_daily]
  WHERE modified_tf = 'F'


-- �۾� 006 -- ������ ���̺��� TM�� ���� ���Ŀ� �°� ���� & �ߺ���ȭ��ȣ ����

DROP TABLE IF EXISTS [work].[dbo].[petition_daily_after]
SELECT 
	[work].[dbo].[petition_daily].[korean_name],
	[work].[dbo].[petition_daily].[modified_number],
	[work].[dbo].[petition_daily].[supporter_email],
	[work].[dbo].[petition_daily].[campaign_date],
	[work].[dbo].[petition_daily].[campaign_name_kr],
	[work].[dbo].[petition_daily].[source]
INTO 
	[work].[dbo].[petition_daily_after]
FROM [work].[dbo].[petition_daily]



-- �۾� 007 -- 1ȸ�� ����

INSERT INTO [work].[dbo].[petition_all]( Year_, Name_, Phone, modified_phone, Mail)
SELECT 
	CONVERT(DATE, GETDATE()), 
	[work].[dbo].[petition_daily_before].[korean_name], 
	[work].[dbo].[petition_daily_before].[phone_number], 
	[work].[dbo].[petition_daily_before].[modified_number],
	[work].[dbo].[petition_daily_before].[supporter_email]
FROM [work].[dbo].[petition_daily_before]	


-- Petition All ������Ʈ Ȯ�� --

SELECT TOP (2000) [Year_]
      ,[Name_]
      ,[Phone]
	  ,[modified_phone]
      ,[Mail]
	  
  FROM [work].[dbo].[petition_all]

  ORDER BY Year_ DESC



-- ��ȭ��ȣ �ߺ� �ڷ� ���� -- 

DROP TABLE IF EXISTS [work].[dbo].[petition_daily_after_rown]
SELECT
 *, ROW_NUMBER() OVER(ORDER BY modified_number) AS ROWN
INTO
 [work].[dbo].[petition_daily_after_rown]
FROM 
 [work].[dbo].[petition_daily_after]


DELETE FROM [work].[dbo].[petition_daily_after_rown]
WHERE ROWN IN
	(SELECT A.ROWN AS ROWN
	FROM [work].[dbo].[petition_daily_after_rown] A
	INNER JOIN 
		(SELECT MAX(ROWN) AS ROWN, modified_number, COUNT(*) AS COUNT
		FROM [work].[dbo].[petition_daily_after_rown] 
		GROUP BY modified_number
		HAVING COUNT(*) > 1) B
	ON A.modified_number = B.modified_number
		AND A.ROWN != B.ROWN)


-- �ڵ�ο� --

INSERT INTO [work].[dbo].[petition_daily_code] 
SELECT korean_name, modified_number, supporter_email, campaign_date, campaign_name_kr, source, convert(date,getdate())
FROM [work].[dbo].[petition_daily_after_rown] 
ORDER BY campaign_name_kr, modified_number

-- ������ ������ �ڷ� ���� --


SELECT 'SK0' + CONVERT(VARCHAR,[code_no]) AS code
      ,[korean_name]
      ,[modified_number]
      ,[supporter_email]
      ,[campaign_date]
      ,[campaign_name_kr]
      ,[source]
	  ,'MPC' AS agency
	  ,[input_date]
FROM [work].[dbo].[petition_daily_code]
WHERE [input_date] = convert(date,getdate())
ORDER BY code