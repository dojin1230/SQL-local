/****** SSMS의 SelectTopNRows 명령 스크립트 ******/
SELECT TOP (1000) [code]
      ,[name]
      ,[phone_number]
      ,[email]
      ,[last_call]
      ,[agency]
  FROM [work].[dbo].[tm_blacklist]


 INSERT INTO [work].[dbo].[tm_blacklist]
 VALUES ('SK0152787','문서아','010-3053-5233','warewed@gmail.com
','2018-01-03','MPC')
