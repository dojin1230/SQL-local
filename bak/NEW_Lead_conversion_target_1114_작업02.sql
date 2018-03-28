-- [work].[dbo].[petition_daily]에 들어가서 양식에 맞지 않는 번호 삭제 및 수정 후 --

-- 작업 006 -- 
DROP TABLE IF EXISTS [work].[dbo].[006]
SELECT 
	[work].[dbo].[petition_daily].[korean_name],
	[work].[dbo].[petition_daily].[modified_number],
	[work].[dbo].[petition_daily].[supporter_email],
	[work].[dbo].[petition_daily].[campaign_date],
	[work].[dbo].[petition_daily].[campaign_name_kr],
	[work].[dbo].[petition_daily].[source]
INTO 
	[work].[dbo].[006]
FROM [work].[dbo].[petition_daily]

-- 작업 007 -- 1회만 실행
/*
INSERT INTO [work].[dbo].[petition_all]( Year_, Name_, Phone, Mail)
SELECT CONVERT(DATE, GETDATE()), [work].[dbo].[004].[korean_name], [work].[dbo].[004].[phone_number], [work].[dbo].[004].[supporter_email]
FROM [work].[dbo].[004]	
*/

-- 중복 전화번호 제거 -- 한 열이라도 중복일 때로 수정
/*
SELECT DISTINCT *
	
FROM [work].[dbo].[006]

ORDER BY supporter_email
*/
