-- [local].[dbo].[petition_daily]에 들어가서 양식에 맞지 않는 번호 삭제 및 수정 후 --

-- 작업 006 -- 수정한 테이블을 TM에 보낼 형식에 맞게 정렬 

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

-- 내보내기 -- 위에서 완성된 테이블을 엑셀로 내보내기 한 후 중복 자료 제거 및 TM에 배정


-- 작업 007 -- 1회만 실행

INSERT INTO [local].[dbo].[petition_all]( Year_, Name_, Phone, Mail)
SELECT CONVERT(DATE, GETDATE()), [local].[dbo].[004].[korean_name], [local].[dbo].[004].[phone_number], [local].[dbo].[004].[supporter_email]
FROM [local].[dbo].[004]	

-- Petition All 업데이트 확인 --

SELECT TOP (1000) [Year_]
      ,[Name_]
      ,[Phone]
      ,[Mail]
  FROM [local].[dbo].[petition_all]

  ORDER BY Year_ DESC



-- 중복 전화번호 제거 -- 한 열이라도 중복일 때로 수정
/*
SELECT DISTINCT *
	
FROM [local].[dbo].[006]

ORDER BY supporter_email
*/
