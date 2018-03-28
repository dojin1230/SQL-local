-- [work].[dbo].[petition_daily]�� ���� ��Ŀ� ���� �ʴ� ��ȣ ���� �� ���� �� --

--  DELETE
--  FROM [work].[dbo].[petition_daily]
--  WHERE modified_tf = 'F'


-- �۾� 006 -- ������ ���̺��� TM�� ���� ���Ŀ� �°� ���� 

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

-- �������� -- ������ �ϼ��� ���̺��� ������ �������� �� �� �ߺ� �ڷ� ���� �� TM�� ����


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


-- ������ ������ petition_daily_after ���� --

SELECT *
FROM [work].[dbo].[petition_daily_after]