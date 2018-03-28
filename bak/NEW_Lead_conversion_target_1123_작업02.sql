-- [local].[dbo].[petition_daily]�� ���� ��Ŀ� ���� �ʴ� ��ȣ ���� �� ���� �� --

-- �۾� 006 -- ������ ���̺��� TM�� ���� ���Ŀ� �°� ���� 

DROP TABLE IF EXISTS [local].[dbo].[006]
SELECT 
	[local].[dbo].[petition_daily].[korean_name],
	[local].[dbo].[petition_daily].[modified_number],
	[local].[dbo].[petition_daily].[supporter_email],
	[local].[dbo].[petition_daily].[campaign_date],
	[local].[dbo].[petition_daily].[campaign_name_kr],
	[local].[dbo].[petition_daily].[source]
INTO 
	[local].[dbo].[006]
FROM [local].[dbo].[petition_daily]

-- �������� -- ������ �ϼ��� ���̺��� ������ �������� �� �� �ߺ� �ڷ� ���� �� TM�� ����


-- �۾� 007 -- 1ȸ�� ����

INSERT INTO [local].[dbo].[petition_all]( Year_, Name_, Phone, Mail)
SELECT CONVERT(DATE, GETDATE()), [local].[dbo].[004].[korean_name], [local].[dbo].[004].[phone_number], [local].[dbo].[004].[supporter_email]
FROM [local].[dbo].[004]	

-- Petition All ������Ʈ Ȯ�� --

SELECT TOP (1000) [Year_]
      ,[Name_]
      ,[Phone]
      ,[Mail]
  FROM [local].[dbo].[petition_all]

  ORDER BY Year_ DESC



-- �ߺ� ��ȭ��ȣ ���� -- �� ���̶� �ߺ��� ���� ����
/*
SELECT DISTINCT *
	
FROM [local].[dbo].[006]

ORDER BY supporter_email
*/
