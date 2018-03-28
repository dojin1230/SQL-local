-- [work].[dbo].[petition_daily]에 들어가서 양식에 맞지 않는 번호 삭제 및 수정 후 --

-- 작업 006 -- 수정한 테이블을 TM에 보낼 형식에 맞게 정렬 

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

-- 내보내기 -- 위에서 완성된 테이블을 엑셀로 내보내기 한 후 중복 자료 제거 및 TM에 배정


-- 작업 007 -- 1회만 실행

INSERT INTO [work].[dbo].[petition_all]( Year_, Name_, Phone, Mail)
SELECT CONVERT(DATE, GETDATE()), [work].[dbo].[petition_daily_before].[korean_name], [work].[dbo].[petition_daily_before].[phone_number], [work].[dbo].[petition_daily_before].[supporter_email]
FROM [work].[dbo].[petition_daily_before]	


-- Petition All 업데이트 확인 --

SELECT TOP (1000) [Year_]
      ,[Name_]
      ,[Phone]
      ,[Mail]
  FROM [work].[dbo].[petition_all]

  ORDER BY Year_ DESC


-- 엑셀로 복사할 petition_daily_after 선택 --

SELECT *
FROM [work].[dbo].[petition_daily_after]