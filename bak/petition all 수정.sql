/****** SSMS의 SelectTopNRows 명령 스크립트 ******/

DROP TABLE IF EXISTS [work].[dbo].[tmp1]
SELECT [Year_]
      ,[Name_]
      ,[Phone]
	  ,REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE([Phone],' ',''),'-',''),'*',''),'.',''),'*',''),'+','') AS phone_number_1,
      [Mail]

INTO [work].[dbo].[tmp1]
FROM [work].[dbo].[petition_all]

-- 작업 002-1 -- 전화번호 앞의 국가번호 82 제거
DROP TABLE IF EXISTS [work].[dbo].[tmp2]
SELECT 
	[Year_],
	[Name_],
	[Phone],
CASE
	WHEN LEFT([phone_number_1],2)='82' THEN SUBSTRING([phone_number_1],3,20)
	ELSE [phone_number_1]
END AS phone_number_2,
    [Mail]

INTO [work].[dbo].[tmp2]
FROM [work].[dbo].[tmp1]

-- 작업 002-2 -- 휴대폰 형식에 맞는 번호에 'comp' 및 '-' 삽입
DROP TABLE IF EXISTS [work].[dbo].[petition_modified]
SELECT 
	[Year_],
	[Name_],
	[Phone],
	CASE 
		WHEN SUBSTRING(phone_number_2,1,3) in ('010','011') AND LEN(phone_number_2)=11 THEN CONCAT(SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,4),'-',SUBSTRING(phone_number_2,8,4))
		WHEN SUBSTRING(phone_number_2,1,2) in ('10','11') AND LEN(phone_number_2)=10 THEN CONCAT('0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,4),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '011' AND LEN(phone_number_2)=10 THEN CONCAT(SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '11' AND LEN(phone_number_2)=9 THEN CONCAT('0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '016' AND LEN(phone_number_2)=10 THEN CONCAT(SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '16' AND LEN(phone_number_2)=9 THEN CONCAT('0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '017' AND LEN(phone_number_2)=10 THEN CONCAT(SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '17' AND LEN(phone_number_2)=9 THEN CONCAT('0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,3) = '019' AND LEN(phone_number_2)=10 THEN CONCAT(SUBSTRING(phone_number_2,1,3),'-',SUBSTRING(phone_number_2,4,3),'-',SUBSTRING(phone_number_2,7,4))
		WHEN SUBSTRING(phone_number_2,1,2) = '19' AND LEN(phone_number_2)=9 THEN CONCAT('0',SUBSTRING(phone_number_2,1,2),'-',SUBSTRING(phone_number_2,3,3),'-',SUBSTRING(phone_number_2,6,4))
		WHEN SUBSTRING(phone_number_2,1,1) in ('2','3','4','5','6','7','8','9') AND LEN(phone_number_2)=8 THEN CONCAT('010','-',SUBSTRING(phone_number_2,1,4),'-',SUBSTRING(phone_number_2,5,4))
		ELSE phone_number_2
	END AS modified_phone,
	[Mail]
INTO [work].[dbo].[petition_modified]
FROM [work].[dbo].[tmp2]