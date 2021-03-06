/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
INSERT INTO [work].[dbo].[tm_blacklist]
SELECT [code]
      ,[name]
      ,

	CASE 
		WHEN SUBSTRING(phone_number,1,3) in ('010','011') AND LEN(phone_number)=11 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,4),'-',SUBSTRING(phone_number,8,4))
		WHEN SUBSTRING(phone_number,1,2) in ('10','11') AND LEN(phone_number)=10 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,4),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,3) = '011' AND LEN(phone_number)=10 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,3),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,2) = '11' AND LEN(phone_number)=9 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,3),'-',SUBSTRING(phone_number,6,4))
		WHEN SUBSTRING(phone_number,1,3) = '016' AND LEN(phone_number)=10 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,3),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,2) = '16' AND LEN(phone_number)=9 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,3),'-',SUBSTRING(phone_number,6,4))
		WHEN SUBSTRING(phone_number,1,3) = '017' AND LEN(phone_number)=10 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,3),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,2) = '17' AND LEN(phone_number)=9 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,3),'-',SUBSTRING(phone_number,6,4))
		WHEN SUBSTRING(phone_number,1,3) = '018' AND LEN(phone_number)=10 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,3),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,2) = '18' AND LEN(phone_number)=9 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,3),'-',SUBSTRING(phone_number,6,4))
		WHEN SUBSTRING(phone_number,1,3) = '019' AND LEN(phone_number)=10 THEN CONCAT(SUBSTRING(phone_number,1,3),'-',SUBSTRING(phone_number,4,3),'-',SUBSTRING(phone_number,7,4))
		WHEN SUBSTRING(phone_number,1,2) = '19' AND LEN(phone_number)=9 THEN CONCAT('0',SUBSTRING(phone_number,1,2),'-',SUBSTRING(phone_number,3,3),'-',SUBSTRING(phone_number,6,4))
		WHEN SUBSTRING(phone_number,1,1) in ('2','3','4','5','6','7','8','9') AND LEN(phone_number)=8 THEN CONCAT('010','-',SUBSTRING(phone_number,1,4),'-',SUBSTRING(phone_number,5,4))
		ELSE phone_number
	END AS phone_number_3

      ,[email]
      ,[last_call]
      ,[agency]
  FROM [work].[dbo].[gp_data]

